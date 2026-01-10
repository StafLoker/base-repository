# Base repository

Language-agnostic development configuration files for any project.

## Contents

### Editor

- `editor/.editorconfig` — Code style consistency across editors

### Git

- `git/.gitignore` — Common ignore patterns
- `git/.gitattributes` — Git attributes configuration

### Licenses

- `licenses/MIT` — MIT License template

### OS

- `os/.gitconfig` — Git configuration with conditional includes for different profiles
- `os/.gitconfig-personal` — Personal Git profile settings (example)
- `os/.gitconfig-work` — Work Git profile settings (example)
- `os/.gitconfig-academic` — Academic Git profile settings (example)

### READMEs

- `readmes/opensource-project.md` — Open source project README template

## Usage

Copy the relevant files to your project root.

The `os/` directory contains system-level Git configuration files meant to be placed in your home directory, not in individual projects. You can create as many or as few profile configurations as needed (personal, work, academic are just examples).

## License

[MIT](LICENSE)