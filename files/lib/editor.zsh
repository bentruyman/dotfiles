(( $+commands[code] )) && {
  export VISUAL="code"
}

(( $+commands[nvim] )) && {
  export EDITOR="nvim"
}

export GIT_EDITOR=$EDITOR

