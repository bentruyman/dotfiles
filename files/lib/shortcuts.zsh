# Filesystem
md() {
  mkdir -p "$1"
  cd "$1" || exit
}

# Navigation
alias ...='cd ../..'
alias ....='cd ../../..'
alias l='ls -al'
alias j="z"

# Misc
function $ () {
  eval "$@"
}
unalias rm 2> /dev/null

# Neovim
alias vclean='rm "$HOME"/.local/share/nvim/swap/*'

# Coding
(( $+commands[prettier] )) && {
  alias pretty="prettier --write '**/*.{js,json,md,scss,ts,vue}'"
}

# Vagrant
alias vagrunt='vagrant destroy -f; vagrant up'
