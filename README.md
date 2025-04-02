# Dotfiles

## Installation

```console
$ curl -L https://raw.githubusercontent.com/bentruyman/dotfiles/main/bootstrap.sh | bash
```

## Features

- Only supports **macOS**
- [Homebrew](https://brew.sh/)
- [Fish shell](https://fishshell.com/) with [Fisher](https://github.com/jorgebucaran/fisher)
- [Neovim](https://neovim.io/) with [AstroNvim](https://astronvim.com/)
- Tmux with [tpm](https://github.com/tmux-plugins/tpm)
- [Ghostty](https://ghostty.org/) terminal

## What the Setup Script Does

The `setup.sh` script automates the setup of a complete macOS development environment:

### System Setup
- Installs Xcode Command Line Tools and Rosetta
- Configures system preferences for keyboard, screenshots, Finder, and Dock
- Sets up TouchID for sudo commands
- Creates necessary dotfiles directories

### Development Tools
- Installs and configures Homebrew with essential packages
- Sets up Git with user configuration
- Configures GPG for signing commits
- Installs Node.js (via Volta) and Rust
- Installs and configures Fish shell with Fisher plugins
- Sets up SSH keys for GitHub

### Applications
- Configures various macOS applications and system preferences
- Sets up a curated Dock with commonly used applications
- Syncs application settings to iCloud via Mackup
- Installs terminal utilities (fzf, tmux plugins, etc.)

### Dotfiles
- Symlinks configuration files to their appropriate locations
- Clones and sets up configurations for Neovim, fzf, and tmux
- Creates machine-specific configuration directories
