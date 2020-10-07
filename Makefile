define HELP_TEXT
clear
echo "Makefile for the JLM evaluation suite"
echo "Version 1.0 - 2019-06-18"
echo ""
echo "Evalution Suite Make Targets"
echo "--------------------------------------------------------------------------------"
echo "submodule              Initializes all the dependent git submodules"
echo "install                Installs the source code, require argument"
echo "                       cpu2017=[name].tar.xz"
echo "all                    Compiles jive, jlm, and llvm-strip"
echo "clean                  Deletes the bin directory"
echo "deep-clean             Calls clean for jive, jlm, polybench, cpu2017, and"
echo "                       csmith."
endef
.PHONY: help
help:
	@$(HELP_TEXT)
	@$(HELP_TEXT_POLYBENCH)
	@$(HELP_TEXT_CPU2017)
	@$(HELP_TEXT_JLM)
	@$(HELP_TEXT_JIVE)
	@$(HELP_TEXT_LLVMSTRIP)
	@$(HELP_TEXT_CSMITH)

SHELL=/bin/bash

# Set these if not using default names for the tools
LLVM_VERSION ?= -7
LLVMCONFIG=llvm-config$(LLVM_VERSION)
CLANG=clang$(LLVM_VERSION)
OPT=opt$(LLVM_VERSION)
LLC=llc$(LLVM_VERSION)
CC=$(CLANG)
CXX=clang++$(LLVM_VERSION)

# Necessary variables
DIR            := $(PWD)
BIN            := $(DIR)/bin
JLM_ROOT       := $(DIR)/jlm
JLM_BIN        := $(JLM_ROOT)/bin
JLC            := $(JLM_BIN)/jlc
JIVE_ROOT      := $(JLM_ROOT)/external/jive
POLYBENCH_ROOT := $(DIR)/polybench
CPU2017_ROOT   := $(DIR)/cpu2017
LLVMSTRIP_ROOT := $(POLYBENCH_ROOT)/external/llvm-strip
CSMITH_ROOT    := $(DIR)/csmith

# Set necessary paths
export PATH := $(BIN):$(JLM_BIN):$(LLVMSTIP_ROOT)/bin/:$(PATH)
export JLMROOT := $(JLM_ROOT)

# Include Makefiles for the tools, libraries, and benchmarks to be built
ifneq ("$(wildcard $(JIVE_ROOT)/Makefile.sub)","")
include $(JIVE_ROOT)/Makefile.sub
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
ifneq ("$(wildcard $(LLVMSTRIP_ROOT)/Makefile.sub)","")
include $(LLVMSTRIP_ROOT)/Makefile.sub
endif
ifneq ("$(wildcard $(CSMITH_ROOT)/Makefile.sub)","")
include $(CSMITH_ROOT)/Makefile.sub
endif

# Silent locale warnings from perl
export LC_CTYPE=en_US.UTF-8

.PHONY: all
all: jive-release jlm-release llvm-strip

### SUBMODULE

.PHONY: submodule
submodule:
	git submodule update --init --recursive

### GENERIC

%.la: %.cpp
	$(CXX) -c $(CFLAGS) $(CPPFLAGS) -o $@ $<

%.la: %.c
	$(CXX) -c $(CFLAGS) $(CPPFLAGS) -o $@ $<

%.a:
	rm -f $@
	ar clqv $@ $^
	ranlib $@

### SYMLINKS

.PHONY: symlinks
symlinks: $(BIN)/llvm-config $(BIN)/clang $(BIN)/opt $(BIN)/llc

$(BIN)/llvm-config:
	@mkdir -p $(BIN)
	@which $(LLVMCONFIG) | xargs -I % sh -c 'ln -s % $@'

$(BIN)/clang:
	@mkdir -p $(BIN)
	@which $(CLANG) | xargs -I % sh -c 'ln -s % $@'

$(BIN)/opt:
	@mkdir -p $(BIN)
	@which $(OPT) | xargs -I % sh -c 'ln -s % $@'

$(BIN)/llc:
	@mkdir -p $(BIN)
	@which $(LLC) | xargs -I % sh -c 'ln -s % $@'

### CLEAN

.PHONY: clean
clean:
	@rm -rf $(BIN)

.PHONY: deep-clean
deep-clean: clean jive-clean jlm-clean polybench-purge llvm-strip-clean csmith-clean
