#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/Development/src/github.com/bentruyman/dotfiles}"

if [[ "$SCRIPT_DIR" != "$DOTFILES_DIR" ]]; then
  [ ! -d "$DOTFILES_DIR" ] && mkdir -p "$DOTFILES_DIR"
  URL="https://github.com/bentruyman/dotfiles/archive/refs/heads/main.tar.gz"
  curl --proto '=https' --tlsv1.2 -sSf "$URL" | tar -xz -C "$DOTFILES_DIR" --strip-components=1
fi

source "$DOTFILES_DIR/setup.sh"
