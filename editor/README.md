# Editor

Consistent code style configuration across editors.

## File

- **`.editorconfig`** — Defines basic formatting rules (charset, line endings, indentation, etc.)

## Usage

Copy `.editorconfig` to your project root. Most modern editors support it natively or via plugins.

## Configuration

General (all files):
- UTF-8 charset, LF line endings
- Insert final newline, trim trailing whitespace
- 2-space indent

Per file type:
- `*.md` — keeps trailing whitespace (line breaks)
- `*.json`, `*.yml`, `*.yaml`, `*.toml` — 2-space indent
- `*.xml` — 4-space indent
- `Makefile` — tabs (required by `make`)
- `*.bat`, `*.cmd` — CRLF line endings

Customize the `## Project ##` section according to your project needs.
