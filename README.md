# Dotfiles

## Installation

```console
$ curl -L https://raw.githubusercontent.com/bentruyman/dotfiles/main/bootstrap.sh | bash
```

`bootstrap.sh` downloads this repository (if needed) and then sources `setup.sh`.
`setup.sh` requires `sudo` and performs interactive steps during first-time setup.

## What This Dotfiles Repo Manages

- macOS-only system provisioning
- Homebrew package and app installation via `Brewfile`
- Fish shell setup with Fisher plugins and Tide prompt defaults
- Neovim configuration (Lazy-based plugin setup)
- tmux configuration plus TPM bootstrap
- fzf bootstrap and shell integration
- Ghostty terminal settings
- Proto installation and Fish PATH integration
- launchd agents from `launch_agents/`

## What `setup.sh` Actually Does

The `setup.sh` script runs these phases:

### 1) Preflight
- Starts a sudo keepalive loop
- Installs Xcode Command Line Tools if missing
- Installs Rosetta if missing

### 2) Dotfiles + Repo Bootstrap
- Symlinks files from `files/` into `$HOME` (for `.bin`, `.config`, `.gitconfig`, `.gitignore_global`, `.mackup.cfg`, `.tmux.conf`)
- Clones `fzf` and `tmux-plugins/tpm` if not already present
- Creates machine-local directories at `~/.dotfiles/fish` and `~/.dotfiles/nvim`

### 3) Launch Agents
- Symlinks plist files from `launch_agents/` into `~/Library/LaunchAgents`
- Loads newly linked agents with `launchctl load`

### 4) Package Provisioning
- Installs Homebrew if missing
- Runs `brew update`, `brew upgrade`, `brew bundle install --file=Brewfile`, and `brew cleanup`
- Accepts Xcode license when Xcode is installed

### 5) Tooling and Identity Setup
- Installs fzf Fish keybindings/completion when not yet configured
- Prompts for Git `user.name` and `user.email` if unset
- Configures GPG pinentry on first run and offers optional private key import
- Installs Proto if `~/.proto` is missing

### 6) macOS Defaults and App Preferences
- Applies defaults for UI mode, keyboard/input behavior, screenshots, Finder, Dock, and Safari menus
- Rebuilds Dock entries for a curated app list when apps exist
- Restarts affected processes (`Dock`, `Finder`, etc.) so settings take effect

### 7) App Settings Sync (Mackup)
- Runs `mackup restore -n` to show differences against backup
- Prints manual follow-up instructions when diffs exist

### 8) Shell Configuration
- Adds Fish to `/etc/shells` if needed
- Changes default shell to Fish when needed
- Installs Fisher if missing
- Installs/updates configured Fisher plugins and runs Tide auto-configuration

### 9) SSH Setup
- Generates an SSH key when `~/.ssh/id_rsa` is missing
- Copies the public key to clipboard
- Opens GitHub SSH key settings page for manual paste

## Machine-Specific Customization

### Fish
Add personal Fish scripts to:

```bash
~/.dotfiles/fish/*.fish
```

Those files are sourced from `files/config/fish/config.fish` when present.

### Neovim
Create:

```lua
~/.config/nvim/lua/user.lua
```

This optional module is loaded via `pcall(require, "user")` and can override:
- `lsp_servers`
- `system_lsp_servers`
- `null_ls_sources`
- `plugins`

## Maintenance / Validation

Use these checks after changing provisioning or shell scripts:

```console
$ brew bundle check --file=Brewfile
$ shellcheck setup.sh bootstrap.sh $(rg -l '^#!/usr/bin/env bash' files/bin)
```

If you change Fish config files, format them with:

```console
$ fish_indent -w files/config/fish/**/*.fish
```
