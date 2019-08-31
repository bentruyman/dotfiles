#!/usr/bin/env zsh
set -e

###############################################################################
# Node.js
###############################################################################

if [[ ! -d "${HOME}/.volta/bin" ]]; then
  curl https://get.volta.sh | bash
  . "${HOME}/.volta/load.sh"
fi

(( $+commands[node] )) && { volta install node; }
(( $+commands[yarn] )) && { volta install yarn; }

volta install \
  dockerfile-language-server-nodejs \
  javascript-typescript-langserver \
  jay-repl \
  livedown \
  neovim \
  yaml-language-server

###############################################################################
# Python/pip
###############################################################################

# Install neovim requirements
pip3 install --user pynvim
