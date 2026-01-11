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

1. **Basic** — Git + Editor configuration
2. **Standard** — Git + Editor + License
3. **Full Open Source** — Git + Editor + License + README
4. **Custom** — Choose individual components

The script will:
- Download selected configuration files
- Customize templates (name, year, etc.)
- Optionally initialize git repository
- Optionally create initial commit

## Contents

- **[editor/](editor/)** — Code style configuration
- **[git/](git/)** — Git ignore patterns and attributes
- **[licenses/](licenses/)** — License templates
- **[os/](os/)** — System-level Git configuration
- **[readmes/](readmes/)** — README templates

## Manual Usage

You can also manually copy the relevant files to your project. See each folder's README for details.

## License

[MIT](LICENSE)