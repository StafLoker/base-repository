# C / C++

Formatting configuration and Make targets for C and C++ projects.

## Files

- **`.clang-format`** — Style rules for C and C++ (4-space indent, 150-column limit, right-aligned pointers, grouped includes)
- **`Makefile`** — `format` and `format-check` targets driving `clang-format`

## Usage

Copy both files to your project root:

```bash
make format        # format all sources in place
make format-check  # fail if anything is unformatted (use in CI)
```

## Requirements

`clang-format` must be installed:

```bash
brew install clang-format          # macOS
sudo apt install clang-format      # Debian/Ubuntu
sudo dnf install clang-tools-extra # Fedora
```

## Configuration

`.clang-format` defines a shared base plus per-language sections: `Language: C`
and `Language: Cpp` (C++17, no namespace indentation, `Cpp11BracedListStyle`).

The include-grouping rules expect sources under `src/` and `include/`, with
project headers in `clients/`, `handlers/` or `models/` sorted last. Adjust
`IncludeCategories` if your layout differs.

The Makefile targets scan `src` and `include` for `*.c`, `*.h`, `*.cpp` and
`*.hpp`. Directories that do not exist are skipped, and with no sources found
both targets report that and succeed rather than failing. Edit `SRC_DIRS` if
your sources live elsewhere.

## Merging into an existing Makefile

The setup script offers to merge rather than replace. Merged output puts these
targets first and your existing rules under a `## Project ##` comment. Check
the result: the **first** target in a Makefile is the default one, so if your
project relied on its own first target, move it back above `format` or add an
explicit `.DEFAULT_GOAL`.
