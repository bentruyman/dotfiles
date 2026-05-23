# Dotfiles

## Installation

```console
$ curl -L https://raw.githubusercontent.com/bentruyman/dotfiles/main/bootstrap.sh | bash
```

`bootstrap.sh` downloads this repository (if needed) and then sources `setup.sh`.
`setup.sh` requires `sudo` and performs interactive steps during first-time setup.

## What This Dotfiles Repo Manages

Supported platforms: macOS (full setup) and Ubuntu 22.04 LTS server (headless,
dev tools only — no casks, MAS apps, launch agents, system defaults, or mackup).

- System provisioning for macOS and Ubuntu 22.04 server
- Homebrew package and app installation via `Brewfile` (Linuxbrew on Ubuntu)
- Fish shell setup with Fisher plugins and Tide prompt defaults
- Neovim configuration (Lazy-based plugin setup)
- tmux configuration plus TPM bootstrap
- fzf bootstrap and shell integration
- Ghostty terminal settings (macOS)
- Proto installation and Fish PATH integration
- launchd agents from `launch_agents/` (macOS)

## What `setup.sh` Actually Does

`setup.sh` detects the OS via `uname -s` and dispatches to the right phases.
Shared logic lives in `lib/common.sh`; platform-specific logic lives in
`lib/macos.sh` and `lib/linux.sh`. Phases run in this order:

`common_preflight` → `${platform}_preflight` → `common_dotfiles` →
`${platform}_postdotfiles` → `common_packages` → `${platform}_postpackages` →
`common_tooling`

### 1) Preflight
- Starts a sudo keepalive loop (shared)
- macOS: installs Xcode Command Line Tools and Rosetta if missing
- Linux: installs Linuxbrew apt prerequisites (`build-essential`, `curl`,
  `file`, `git`, `procps`, `gawk`, `ca-certificates`)

### 2) Dotfiles + Repo Bootstrap
- Symlinks files from `files/` into `$HOME` (for `.bin`, `.config`, `.gitconfig`, `.gitignore_global`, `.mackup.cfg`, `.tmux.conf`)
- Clones `fzf` and `tmux-plugins/tpm` if not already present
- Creates machine-local directories at `~/.dotfiles/fish` and `~/.dotfiles/nvim`

### 3) Launch Agents (macOS only)
- Symlinks plist files from `launch_agents/` into `~/Library/LaunchAgents`
- Loads newly linked agents with `launchctl load`

### 4) Package Provisioning
- Installs Homebrew if missing (Linuxbrew on Linux, into
  `/home/linuxbrew/.linuxbrew`)
- Runs `brew update`, `brew upgrade`, `brew bundle install --file=Brewfile`,
  and `brew cleanup`. Casks, MAS apps, and macOS-only formulae in `Brewfile`
  are gated on `if OS.mac?` so they're skipped on Linux.
- Accepts Xcode license when Xcode is installed (macOS)

### 5) Tooling and Identity Setup
- Installs fzf Fish keybindings/completion when not yet configured
- Prompts for Git `user.name` and `user.email` if unset
- Configures GPG pinentry on first run and offers optional private key import
  (macOS only)
- Installs Proto if `~/.proto` is missing

### 6) macOS Defaults and App Preferences (macOS only)
- Applies defaults for UI mode, keyboard/input behavior, screenshots, Finder,
  Dock, and Safari menus
- Rebuilds Dock entries for a curated app list when apps exist
- Restarts affected processes (`Dock`, `Finder`, etc.) so settings take effect

### 7) App Settings Sync (Mackup, macOS only)
- Runs `mackup restore -n` to show differences against backup
- Prints manual follow-up instructions when diffs exist

### 8) Shell Configuration
- Adds Fish to `/etc/shells` if needed
- Changes default shell to Fish when needed
- Installs Fisher if missing
- Installs/updates configured Fisher plugins and runs Tide auto-configuration

### 9) SSH Setup
- Generates an SSH key when `~/.ssh/id_rsa` is missing
- macOS: copies the public key to clipboard and opens GitHub SSH key settings
- Linux: prints the public key to stdout for manual copy

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
$ shellcheck setup.sh bootstrap.sh lib/*.sh $(rg -l '^#!/usr/bin/env bash' files/bin)
```

If you change Fish config files, format them with:

```console
$ fish_indent -w files/config/fish/**/*.fish
```

To smoke-test the Linux provisioning end to end, use the included
`Dockerfile.test`. `setup.sh` runs as the `CMD`, so the build itself does
not provision; running the container is what kicks off the full setup.

```console
$ ./test.sh                                      # build, then run setup interactively
$ docker build -f Dockerfile.test -t dotfiles-test --progress=plain .
$ docker run --rm -it dotfiles-test              # run setup.sh end to end
$ docker run --rm -it dotfiles-test bash -l      # poke around without running setup
```
