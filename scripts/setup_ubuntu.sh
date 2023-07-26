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

if ! command -v brew &>/dev/null; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew update
brew upgrade

brew bundle install --file="${SCRIPT_DIR}/brew/agnostic/Brewfile"
brew bundle install --file="${SCRIPT_DIR}/brew/ubuntu/Brewfile"

brew cleanup
