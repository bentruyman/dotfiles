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
unalias rm 2> /dev/null

# Vagrant
alias vagrunt='vagrant destroy -f; vagrant up'
