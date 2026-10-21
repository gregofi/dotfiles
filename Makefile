# Every directory in linked/ is a Stow package.
# Override to pick a subset, e.g. `make link PACKAGES="nvim fish"`.
STOW_DIR := $(CURDIR)/linked
PACKAGES ?= $(notdir $(patsubst %/,%,$(wildcard $(STOW_DIR)/*/)))

STOW := stow --dir=$(STOW_DIR) --target=$(HOME)

.PHONY: link unlink relink dry-run list

link:
	$(STOW) $(PACKAGES)

unlink:
	$(STOW) -D $(PACKAGES)

relink:
	$(STOW) -R $(PACKAGES)

dry-run:
	$(STOW) -n -v $(PACKAGES)

list:
	@echo $(PACKAGES)
