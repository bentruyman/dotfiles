#!/usr/bin/env bash
set -e

[[ "$(cat /etc/lsb-release 2> /dev/null | head -1 2> /dev/null)" =~ Ubuntu ]] || return 0

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
  software-properties-common \
  unzip \
  zsh

###############################################################################
# Linuxbrew
###############################################################################

if ! hash brew &> /dev/null; then
  /bin/bash -c "$(NONINTERACTIVE=1 curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  sudo chown $USER "$HOME/.cache"
fi

brew update
brew upgrade

brew bundle install --file="${SCRIPT_DIR}/brew/agnostic/Brewfile"
brew bundle install --file="${SCRIPT_DIR}/brew/ubuntu/Brewfile"

brew cleanup

###############################################################################
# Shell
###############################################################################

# Change shell to ZSH
ZSH_BIN="/usr/bin/zsh"
if [[ "$SHELL" != "$ZSH_BIN" ]]; then
  sudo chsh -s "$ZSH_BIN" "$USER"
fi

$ZSH_BIN -i "${SCRIPT_DIR}/postsetup.zsh"
