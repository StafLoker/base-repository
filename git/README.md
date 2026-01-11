# Git

Git configuration for ignoring files and normalizing attributes.

## Files

- **`.gitignore`** — File patterns to ignore (macOS, Windows, VS Code)
- **`.gitattributes`** — Line ending normalization and text file configuration

## Usage

Copy these files to your project root.

## Contents

### .gitignore
Includes common patterns for:
- macOS system files (.DS_Store, etc.)
- Windows system files (Thumbs.db, etc.)
- VS Code configuration

Add project-specific patterns in the `## Project ##` section.

### .gitattributes
Configures:
- Automatic line ending normalization (LF in repository)
- Specific line endings for scripts (.sh → LF, .bat/.cmd → CRLF)
