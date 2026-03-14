APPS := $(sort $(shell find . -mindepth 1 -maxdepth 1 -type d ! -name '.*' -exec basename {} \;))
TARGET := ~
STOW_ALL := $(filter all,$(MAKECMDGOALS))
REQUESTED_APPS := $(filter-out help stow unstow all,$(MAKECMDGOALS))
NOOP_TARGETS := $(filter-out help stow unstow,$(MAKECMDGOALS))

.DEFAULT_GOAL := help
.PHONY: help stow unstow all $(NOOP_TARGETS)

help:
	@echo "Available commands:"
	@echo "  make stow all"
	@echo "  make stow <app> [app-2 ...]"
	@echo "  make unstow <app> [app-2 ...]"
	@echo ""
	@echo "Available apps: $(APPS)"

stow:
ifeq ($(strip $(STOW_ALL)),all)
ifneq ($(strip $(REQUESTED_APPS)),)
	@echo "Usage: make stow all | make stow <app> [app-2 ...]" >&2
	@exit 1
else
	stow -t $(TARGET) $(APPS)
endif
else
ifneq ($(strip $(REQUESTED_APPS)),)
	stow -t $(TARGET) $(REQUESTED_APPS)
else
	@echo "Usage: make stow all | make stow <app> [app-2 ...]" >&2
	@exit 1
endif
endif

unstow:
ifeq ($(strip $(REQUESTED_APPS)),)
	@echo "Usage: make unstow <app> [app-2 ...]" >&2
	@exit 1
else
	stow -D -t $(TARGET) $(REQUESTED_APPS)
endif

ifneq ($(strip $(NOOP_TARGETS)),)
$(NOOP_TARGETS):
	@:
endif
