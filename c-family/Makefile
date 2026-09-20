# Directories to scan (only those that exist)
SRC_DIRS := $(wildcard src include)
SOURCES  := $(if $(SRC_DIRS),$(shell find $(SRC_DIRS) -type f \( -name '*.c' -o -name '*.h' -o -name '*.cpp' -o -name '*.hpp' \)))

# Format code
format:
	@echo "Formatting C/C++ files..."
	@$(if $(SOURCES),clang-format -i $(SOURCES),echo "No C/C++ sources found in: $(or $(SRC_DIRS),src include)")
	@echo "Done!"

format-check:
	@echo "Checking C/C++ formatting..."
	@$(if $(SOURCES),clang-format --dry-run --Werror $(SOURCES),echo "No C/C++ sources found in: $(or $(SRC_DIRS),src include)")

.PHONY: format format-check
