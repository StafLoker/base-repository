# OS

System-level Git configuration with multiple profiles.

## Files

- **`.gitconfig`** — Main configuration with conditional includes
- **`.gitconfig-personal`** — Profile for personal projects
- **`.gitconfig-work`** — Profile for work projects
- **`.gitconfig-academic`** — Profile for academic projects

## Usage

1. Copy the files to your home directory (`~/`)
2. Edit `.gitconfig` and replace paths with your project directories
3. Customize each profile file with your name, email, and GPG key
4. Remove profiles you don't need

## Features

### Main configuration
- Default branch: `main`
- Merge without fast-forward
- Pull with fast-forward
- GPG program configured

### Profiles
Each profile allows configuring:
- User name
- Email
- GPG signing key
- Automatic signing of commits and tags

## Example

If your personal projects are in `~/personal/` and work projects in `~/work/`, edit `.gitconfig`:

```
[includeIf "gitdir:~/personal/"]
    path = .gitconfig-personal
[includeIf "gitdir:~/work/"]
    path = .gitconfig-work
```
