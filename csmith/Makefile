define HELP_TEXT
clear
echo "Makefile for csmith"
echo "Version 1.0 - 2020-10-05"
endef
.PHONY: help
help:
	@$(HELP_TEXT)
	@$(HELP_TEXT_CSMITH)
	@echo "submodule              Initialises all the dependent git submodules"
	@echo "install                Alias for csmith-install"
	@echo "run                    Alias for csmith-run"
	@echo "compare                Alias for csmith-compare"
	@echo "clean                  Alias for csmith-clean"
	@echo "purge                  Alias for csmith-purge"

CSMITH_ROOT ?= .
JLM_ROOT = ../jlm
JLM_BIN  = $(JLM_ROOT)/bin
JLC      = $(JLM_BIN)/jlc

LLVM_VERSION ?= -7
LLVMCONFIG=llvm-config$(LLVM_VERSION)
CLANG=clang$(LLVM_VERSION)

# Set necessary paths
export PATH    := $(JLM_BIN):$(PATH)
export JLMROOT := $(JLM_ROOT)

include $(CSMITH_ROOT)/Makefile.sub

.PHONY: submodule
submodule:
	git submodule update --init

.PHONY: install
install: csmith-install

.PHONY:run
run: csmith-run

.PHONY: compare
compare: csmith-compare

.PHONY: clean
clean: csmith-clean

.PHONY: purge
purge: csmith-purge
