# Format code
format:
	@echo "Formatting C/C++ files..."
	@find src include -type f \( -name '*.c' -o -name '*.h' -o -name '*.cpp' -o -name '*.hpp' \) -exec clang-format -i {} +
	@echo "Done!"

format-check:
	@echo "Checking C/C++ formatting..."
	@find src include -type f \( -name '*.c' -o -name '*.h' -o -name '*.cpp' -o -name '*.hpp' \) -exec clang-format --dry-run --Werror {} +

.PHONY: format format-check
