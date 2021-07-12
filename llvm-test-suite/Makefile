define HELP_TEXT
clear
echo "Makefile for the llvm-test-suite"
echo "Version 1.0 - 2021-07-09"
endef
.PHONY: help
help:
	@$(HELP_TEXT)
	@$(HELP_TEXT_LLVM_TEST)

LLVM_TEST_ROOT=$(PWD)
JLC = jlc
CLANG = clang

include $(LLVM_TEST_ROOT)/Makefile.sub
