#!/usr/bin/env bash
set -e

###############################################################################
# Node.js
###############################################################################

if ! hash fnm &> /dev/null; then
  curl https://raw.githubusercontent.com/Schniz/fnm/master/.ci/install.sh | bash -s --skip-shell
fi

# TODO: need to use the globally installed version of npm
npm install -g \
  dockerfile-language-server-nodejs \
  javascript-typescript-langserver \
  neovim \
  yaml-language-server

###############################################################################
# Python/pip
###############################################################################

# Install neovim requirements
pip3 install --user pynvim
