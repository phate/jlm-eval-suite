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
echo "all                    Compiles jlm"
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
	@$(HELP_TEXT_CIRCT)

SHELL=/bin/bash

# LLVM related variables
CLANG_BIN=$(shell $(LLVMCONFIG) --bindir)
CLANG=$(CLANG_BIN)/clang
CC=$(CLANG)
CXX=$(CLANG_BIN)/clang++

# Necessary variables
DIR            := $(PWD)
JLM_ROOT       := $(DIR)/jlm
JLM_BIN        := $(JLM_ROOT)/bin
JLC            := $(JLM_BIN)/jlc
HLS            := $(JLM_BIN)/jhls
POLYBENCH_ROOT := $(DIR)/polybench
CPU2017_ROOT   := $(DIR)/cpu2017
CSMITH_ROOT    := $(DIR)/csmith
LLVM_TEST_ROOT := $(DIR)/llvm-test-suite
CIRCT_ROOT     := $(DIR)/circt
VERILATOR_ROOT := $(DIR)/verilator
HLS_TEST_ROOT  := $(DIR)/hls-test-suite

# Set necessary paths
export PATH := $(JLM_BIN):$(PATH)
export JLMROOT := $(JLM_ROOT)

# Include Makefiles for the tools, libraries, and benchmarks to be built
ifneq ("$(wildcard Makefile-circt.sub)","")
include Makefile-circt.sub
endif
ifneq ("$(wildcard $(JLM_ROOT)/Makefile.sub)","")
include $(JLM_ROOT)/Makefile.sub
endif
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
all: jlm-release

### SUBMODULE

.PHONY: submodule
submodule:
	git -c submodule.cpu2017.update=none \
		-c submodule.circt.update=none \
		submodule update --init --recursive

.PHONY: submodule-cpu2017
submodule-cpu2017:
	git -c submodule update --init --recursive $(CPU2017_ROOT)

.PHONY: submodule-circt
submodule-circt:
	git submodule update --init --recursive $(CIRCT_ROOT)

.PHONY: submodule-all
submodule-all: submodule submodule-cpu2017 submodule-circt

### GENERIC

%.la: %.cpp
	$(CXX) -c $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

%.la: %.c
	$(CXX) -c $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

%.a:
	rm -f $@
	ar cqv $@ $^
	ranlib $@

### CLEAN

.PHONY: clean
clean: jlm-clean polybench-purge cpu2017-clean csmith-clean llvm-test
