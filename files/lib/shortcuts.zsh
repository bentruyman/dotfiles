# Filesystem
md() {
  mkdir -p "$1"
  cd "$1" || exit
}

# Navigation
alias ...='cd ../..'
alias ....='cd ../../..'
alias l='ls -al'

# Git
alias ga='git add -Av'
alias gd='git diff'
alias gdc='git diff --cached'
alias gst='git status'

# Misc
function $ () {
  eval "$@"
}
unalias rm 2> /dev/null

# Neovim

alias vclean='rm "$HOME"/.local/share/nvim/swap/*'

# Vagrant
alias vagrunt='vagrant destroy -f; vagrant up'
