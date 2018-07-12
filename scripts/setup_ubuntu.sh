#!/usr/bin/env bash
set -e

[[ "$(cat /etc/lsb-release 2> /dev/null | head -1 2> /dev/null)" =~ Ubuntu ]] || exit 0

export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

###############################################################################
# apt-get
###############################################################################

sudo apt-get update

sudo apt-get install -y \
  build-essential \
  curl \
  git \
  python3-setuptools \
  software-properties-common

###############################################################################
# Linuxbrew
###############################################################################

if ! hash brew &> /dev/null; then
  # TRAVIS=1 prevents the installer from waiting for user input
  TRAVIS=1 sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
fi

brew update
brew upgrade

brew bundle install --file="$SCRIPT_DIR/brew/agnostic/Brewfile"
brew bundle install --file="$SCRIPT_DIR/brew/ubuntu/Brewfile"

brew cleanup

###############################################################################
# Shell
###############################################################################

ZSH_BIN="/home/linuxbrew/.linuxbrew/bin/zsh"

# Add ZSH to list of valid shells
if ! grep -q "$ZSH_BIN" /etc/shells; then
  echo "$ZSH_BIN" | sudo tee -a /etc/shells &> /dev/null
fi

# Change shell to ZSH
if [[ "$SHELL" != "$ZSH_BIN" ]]; then
  sudo chsh -s "$ZSH_BIN" "$USER"
fi
