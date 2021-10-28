#!/usr/bin/env zsh
set -e

###############################################################################
# Node.js
###############################################################################

if [[ ! -d "${HOME}/.volta/bin" ]]; then
  curl https://get.volta.sh | bash
fi

(( $+commands[node] )) && { volta install node; }
(( $+commands[yarn] )) && { volta install yarn; }

volta install \
  livedown \
  neovim

###############################################################################
# Python/pip
###############################################################################

# Install neovim requirements
pip3 install --user pynvim
