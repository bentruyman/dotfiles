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

if [[ ! -d "${HOME}/.volta/bin" ]]; then
  curl https://get.volta.sh | bash -s -- --skip-setup
fi

PATH="${HOME}/.volta/bin:${PATH}"

volta setup > /dev/null

! type node > /dev/null && volta install node

###############################################################################
# Rust
###############################################################################

if [[ ! -f "${HOME}/.cargo/env" ]]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi
