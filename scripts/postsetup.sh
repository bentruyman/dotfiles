#!/usr/bin/env bash
set -e

###############################################################################
# Node.js
###############################################################################

if ! hash fnm &> /dev/null; then
  curl https://raw.githubusercontent.com/Schniz/fnm/master/.ci/install.sh | bash -s --skip-shell
fi

###############################################################################
# Python/pip
###############################################################################

# Install neovim requirements
pip3 install --user pynvim
