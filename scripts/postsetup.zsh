#!/usr/bin/env bash
set -e

###############################################################################
# FZF
###############################################################################

if [[ ! -f "${HOME}/.fzf.zsh" ]]; then
  $HOME/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
fi

###############################################################################
# Node.js
###############################################################################

if [ ! -d "${HOME}/.volta/bin" ]; then
  curl https://get.volta.sh | bash -s -- --skip-setup
fi

export PATH="${HOME}/.volta/bin:${PATH}"

if ! command -v node > /dev/null; then
  volta install node
fi

###############################################################################
# Rust
###############################################################################

if [[ ! -f "${HOME}/.cargo/env" ]]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

###############################################################################
# Shell
###############################################################################

ZSH_BIN=$(command -v zsh 2> /dev/null)

# Add ZSH to list of valid shells
if [[ -x "$ZSH_BIN" ]] && ! grep -q "$ZSH_BIN" /etc/shells; then
  echo "$ZSH_BIN" | sudo tee -a /etc/shells &> /dev/null
fi

# Change shell to ZSH
if [[ "$SHELL" != "$ZSH_BIN" ]]; then
  sudo chsh -s "$ZSH_BIN" "$USER"
fi
