define HELP_TEXT
clear
echo "Makefile for the JLM evaluation suite"
echo "Version 1.0 - 2019-06-18"
echo ""
echo "Evalution Suite Make Targets"
echo "--------------------------------------------------------------------------------"
echo "all                    Compiles jive, jlm, and llvm-strip"
echo "clean                  Deletes the bin directory"
echo "deep-clean             Calls clean for jive, jlm, and polybench."
endef
.PHONY: help
help:
	@$(HELP_TEXT)
	@$(HELP_TEXT_POLYBENCH)
	@$(HELP_TEXT_JLM)
	@$(HELP_TEXT_JIVE)
	@$(HELP_TEXT_LLVMSTRIP)

# Set these if not using default names for the tools
LLVMCONFIG=llvm-config-7
CLANG=clang-7
OPT=opt-7
LLC=llc-7

# Necessary variables
DIR := .
BIN := $(DIR)/bin
JLM_ROOT := $(DIR)/jlm
JIVE_ROOT := $(JLM_ROOT)/external/jive
POLYBENCH_ROOT := $(DIR)/polybench-jlm
LLVMSTRIP_ROOT := $(POLYBENCH_ROOT)/external/llvm-strip

# Set necessary paths
export PATH := $(BIN):$(JLM_ROOT)/bin:$(PATH)
export JLMROOT := $(JLM_ROOT)

# Include Makefiles for the tools, libraries, and benchmarks to be built
include $(JIVE_ROOT)/Makefile.sub
include $(JLM_ROOT)/Makefile.sub
include $(POLYBENCH_ROOT)/Makefile.sub
include $(LLVMSTRIP_ROOT)/Makefile.sub

# Silent locale warnings from perl
export LC_CTYPE=en_US.UTF-8

# Compilation flags
LDFLAGS += $(shell $(LLVMCONFIG) --libs core irReader) $(shell $(LLVMCONFIG) --ldflags) $(shell $(LLVMCONFIG) --system-libs) -L$(JIVE_ROOT)

OPTFLAGS=`llvm-as < /dev/null | opt -O3 -disable-output -debug-pass=Arguments 2>&1 | awk '{if(NR==2)print}' | sed 's/Pass Arguments: //' | sed 's/-loop-vectorize //' | sed 's/-slp-vectorize //'`
export OPTCFLAGS := $(OPTFLAGS)
export JLMFLAGS := --iln --inv --red --dne --ivt --inv --dne --psh --inv --dne --url --inv --red --cne --dne --pll --inv --dne

.PHONY: all
all: jive jlm llvm-strip

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
deep-clean: clean jive-clean jlm-clean polybench-clean-all llvm-strip-clean
