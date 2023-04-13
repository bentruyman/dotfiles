#!/usr/bin/env bash
set -e

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
