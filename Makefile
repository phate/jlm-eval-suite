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
echo "all                    Compiles jive and jlm"
echo "clean                  Calls clean for jive, jlm, polybench, cpu2017, and"
echo "                       csmith."
endef
.PHONY: help
help:
	@$(HELP_TEXT)
	@$(HELP_TEXT_POLYBENCH)
	@$(HELP_TEXT_CPU2017)
	@$(HELP_TEXT_JLM)
	@$(HELP_TEXT_JIVE)
	@$(HELP_TEXT_CSMITH)

SHELL=/bin/bash

# LLVM related variables
LLVMCONFIG ?= llvm-config-10
CLANG_BIN=$(shell $(LLVMCONFIG) --bindir)
CLANG=$(CLANG_BIN)/clang
CC=$(CLANG)
CXX=$(CLANG_BIN)/clang++

# Necessary variables
DIR            := $(PWD)
JLM_ROOT       := $(DIR)/jlm
JLM_BIN        := $(JLM_ROOT)/bin
JLC            := $(JLM_BIN)/jlc
JIVE_ROOT      := $(JLM_ROOT)/external/jive
POLYBENCH_ROOT := $(DIR)/polybench
CPU2017_ROOT   := $(DIR)/cpu2017
CSMITH_ROOT    := $(DIR)/csmith

# Set necessary paths
export PATH := $(JLM_BIN):$(PATH)
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
ifneq ("$(wildcard $(CSMITH_ROOT)/Makefile.sub)","")
include $(CSMITH_ROOT)/Makefile.sub
endif

# Silent locale warnings from perl
export LC_CTYPE=en_US.UTF-8

.PHONY: all
all: jive-release jlm-release

### SUBMODULE

.PHONY: submodule
submodule:
	git submodule update --init --recursive

### GENERIC

%.la: %.cpp
	$(CXX) -c $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

%.la: %.c
	$(CXX) -c $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

%.a:
	rm -f $@
	ar clqv $@ $^
	ranlib $@

### CLEAN

.PHONY: clean
clean: jive-clean jlm-clean polybench-purge cpu2017-clean csmith-clean
