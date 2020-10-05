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

SCMITH_ROOT ?= .

include $(SCMITH_ROOT)/Makefile.sub

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
