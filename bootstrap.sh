#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/Development/src/github.com/bentruyman/dotfiles}"

if [[ ! -d "$DOTFILES_DIR" ]]; then
  mkdir -p "$DOTFILES_DIR"
  URL="https://github.com/bentruyman/dotfiles/archive/refs/heads/main.tar.gz"
  curl -sSL "$URL" | tar -xz -C "$DOTFILES_DIR" --strip-components=1
fi

source "$DOTFILES_DIR/setup.sh"
