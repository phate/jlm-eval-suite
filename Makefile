define HELP_TEXT
clear
echo "Makefile for the JLM evaluation suite"
echo "Version 1.0 - 2019-06-18"
echo ""
echo "Evalution Suite Make Targets"
echo "--------------------------------------------------------------------------------"
echo "submodule              Initializes all the dependent git submodules except"
echo "                       cpu2017 since it requires private access"
echo "submodule-2017         Initializes all the dependent git submodules including"
echo "                       cpu2017"
echo "all                    Compiles CIRCT and the release version of jlm with the"
echo "                       HLS backend enabled"
echo "jlm-configure-debug    Configure jlm to build the debug version"
echo "jlm-configure-release  Configure jlm to build the release version"
echo "jlm-build              Builds the configured version of jlm"
echo "jlm-clean              Calls clean for jlm"
echo "clean                  Calls clean for jlm, polybench, cpu2017, csmith,"
echo "                       and llvm-test."
endef
.PHONY: help
help:
	@$(HELP_TEXT)
	@$(HELP_TEXT_POLYBENCH)
	@$(HELP_TEXT_CPU2017)
	@$(HELP_TEXT_LLVM_TEST)
	@$(HELP_TEXT_JLM)
	@$(HELP_TEXT_CSMITH)
	@$(HELP_TEXT_HLS_TEST)

SHELL=/bin/bash

# LLVM related variables
CLANG_BIN=$(shell $(LLVMCONFIG) --bindir)
CLANG=$(CLANG_BIN)/clang
CC=$(CLANG)
CXX=$(CLANG_BIN)/clang++

# Necessary variables
DIR            := $(PWD)
JLM_ROOT       := $(DIR)/jlm
JLM_BIN        := $(JLM_ROOT)/build
JLC            := $(JLM_BIN)/jlc
HLS            := $(JLM_BIN)/jhls
POLYBENCH_ROOT := $(DIR)/polybench
CPU2017_ROOT   := $(DIR)/cpu2017
CSMITH_ROOT    := $(DIR)/csmith
LLVM_TEST_ROOT := $(DIR)/llvm-test-suite
VERILATOR_ROOT := $(DIR)/verilator
HLS_TEST_ROOT  := $(DIR)/hls-test-suite

# Set necessary paths
export PATH := $(JLM_BIN):$(PATH)
export JLMROOT := $(JLM_ROOT)

ifneq ("$(wildcard $(POLYBENCH_ROOT)/Makefile.sub)","")
include $(POLYBENCH_ROOT)/Makefile.sub
endif
ifneq ("$(wildcard $(CPU2017_ROOT)/Makefile.sub)","")
include $(CPU2017_ROOT)/Makefile.sub
endif
ifneq ("$(wildcard $(CSMITH_ROOT)/Makefile.sub)","")
include $(CSMITH_ROOT)/Makefile.sub
endif
ifneq ("$(wildcard $(LLVM_TEST_ROOT)/Makefile.sub)","")
include $(LLVM_TEST_ROOT)/Makefile.sub
endif
ifneq ("$(wildcard Makefile-verilator.sub)","")
include Makefile-verilator.sub
endif
ifneq ("$(wildcard $(HLS_TEST_ROOT)/Makefile.sub)","")
include $(HLS_TEST_ROOT)/Makefile.sub
endif

# Silent locale warnings from perl
export LC_CTYPE=en_US.UTF-8

.PHONY: all
all: circt-build jlm-configure-release jlm-build

### SUBMODULE

.PHONY: submodule
submodule:
	git -c submodule.cpu2017.update=none \
		submodule update --init --recursive

.PHONY: submodule-cpu2017
submodule-cpu2017:
	git -c submodule update --init --recursive $(CPU2017_ROOT)

.PHONY: submodule-all
submodule-all: submodule submodule-cpu2017

### GENERIC

%.la: %.cpp
	$(CXX) -c $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

%.la: %.c
	$(CXX) -c $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

%.a:
	rm -f $@
	ar cqv $@ $^
	ranlib $@

### JLM

CIRCT_PATH ?= $(JLM_ROOT)/build-circt/circt

.PHONY: jlm-configure-debug
jlm-configure-debug:
	@cd $(JLM_ROOT) && \
	./configure.sh --enable-asserts --enable-hls $(CIRCT_PATH) --target debug CXX=clang++-16

.PHONY: jlm-configure-release
jlm-configure-release:
	@cd $(JLM_ROOT) && \
	./configure.sh --enable-asserts --enable-hls $(CIRCT_PATH) --target release CXX=clang++-16

.PHONY: jlm-build
jlm-build: $(JLM_ROOT)/Makefile.config
	@make -C $(JLM_ROOT) -j `nproc` -O

### CIRCT

.PHONY: circt-build
circt-build: $(CIRCT_PATH)

$(CIRCT_PATH):
	$(JLM_ROOT)/scripts/build-circt.sh \
		--build-path $(JLM_ROOT)/build-circt \
		--install-path $(CIRCT_PATH)

### CLEAN

.PHONY: clean
clean: jlm-clean polybench-purge cpu2017-clean csmith-clean llvm-clean

.PHONY: jlm-clean
jlm-clean:
	@make -C $(JLM_ROOT) distclean
