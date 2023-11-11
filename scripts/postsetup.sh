#!/usr/bin/env bash
set -e

###############################################################################
# FZF
###############################################################################

if [[ ! -f "${HOME}/.fzf.zsh" ]]; then
  $HOME/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-zsh
fi

###############################################################################
# GPG
###############################################################################

if [[ ! -d "${HOME}/.gnupg" ]]; then
  mkdir "${HOME}/.gnupg"
  echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" >"${HOME}/.gnupg/gpg-agent.conf"
  echo 'use-agent' >"${HOME}/.gnupg/gpg.conf"
  chmod 700 "${HOME}/.gnupg"
  killall gpg-agent
fi

###############################################################################
# Node.js
###############################################################################

if [ ! -d "${HOME}/.volta/bin" ]; then
  curl https://get.volta.sh | bash -s -- --skip-setup
fi

export PATH="${HOME}/.volta/bin:${PATH}"

if ! command -v node >/dev/null; then
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

FISH_BIN=$(command -v fish 2>/dev/null)

# Add FISH to list of valid shells
if [[ -x "$FISH_BIN" ]] && ! grep -q "$FISH_BIN" /etc/shells; then
  echo "$FISH_BIN" | sudo tee -a /etc/shells &>/dev/null
fi

# Change shell to Fish
if [[ "$SHELL" != "$FISH_BIN" ]]; then
  sudo chsh -s "$FISH_BIN" "$USER"
fi
