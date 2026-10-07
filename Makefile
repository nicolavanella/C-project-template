# ----------------------------------------------------------------------
# Project
# ----------------------------------------------------------------------
BUILD_DIR := build
CONFIG ?= Debug

# ----------------------------------------------------------------------
# Tools
# ----------------------------------------------------------------------
CMAKE := cmake
CTEST := ctest

# ----------------------------------------------------------------------
# Platform
# ----------------------------------------------------------------------
ifeq ($(OS),Windows_NT)
    RM := rmdir /S /Q
    CMAKE_BUILD_CONFIG := --config $(CONFIG)
    CTEST_CONFIG := -C $(CONFIG)
else
    RM := rm -rf
    CMAKE_BUILD_CONFIG :=
    CTEST_CONFIG :=
endif

# ----------------------------------------------------------------------
# Default target
# ----------------------------------------------------------------------
.PHONY: all
all: build

# ----------------------------------------------------------------------
# Configure
# ----------------------------------------------------------------------
.PHONY: configure
configure:
	$(CMAKE) -B $(BUILD_DIR) -S .

# ----------------------------------------------------------------------
# Build
# ----------------------------------------------------------------------
.PHONY: build
build: configure
	$(CMAKE) --build $(BUILD_DIR) $(CMAKE_BUILD_CONFIG)

# ----------------------------------------------------------------------
# Test
# ----------------------------------------------------------------------
.PHONY: test
test: build
	$(CTEST) --test-dir $(BUILD_DIR) $(CTEST_CONFIG) --output-on-failure

# ----------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------
.PHONY: clean
clean:
	$(RM) $(BUILD_DIR)

# ----------------------------------------------------------------------
# Rebuild
# ----------------------------------------------------------------------
.PHONY: rebuild
rebuild: clean build

# ----------------------------------------------------------------------
# Help
# ----------------------------------------------------------------------
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  make configure              Configure the CMake project"
	@echo "  make build                  Build the project"
	@echo "  make test                   Build and run tests"
	@echo "  make clean                  Remove the build directory"
	@echo "  make rebuild                Clean and build the project"
	@echo "  make build CONFIG=Release   Build Release configuration"
	@echo "  make test CONFIG=Release    Test Release configuration"
	@echo "  make help                   Show this help"