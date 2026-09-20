# Base Repository

Language-agnostic configuration files for any project.

## Quick Setup

Run this command in your project directory to interactively set up configuration files:

**Using curl:**
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/StafLoker/base-repository/main/setup.sh)"
```

**Using wget:**
```bash
bash -c "$(wget -qO- https://raw.githubusercontent.com/StafLoker/base-repository/main/setup.sh)"
```

### Templates Available

1. **Basic** — Git configuration (offers License, README and C/C++ afterward)
2. **Standard** — Git + README (offers License and C/C++ afterward)
3. **Custom** — Choose individual components, including C/C++

The script will:
- Download selected configuration files
- Customize templates (name, year, etc.)
- Optionally initialize git repository
- Optionally create initial commit

## Contents

- **[c-family/](c-family/)** — C/C++ formatting config and Makefile targets
- **[git/](git/)** — Git ignore patterns and attributes
- **[licenses/](licenses/)** — License templates
- **[os/](os/)** — System-level Git configuration
- **[readmes/](readmes/)** — README templates

## Manual Usage

You can also manually copy the relevant files to your project. See each folder's README for details.

## License

[MIT](LICENSE)