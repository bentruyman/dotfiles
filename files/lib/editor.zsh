export ALTERNATE_EDITOR=""
export EDITOR="vim"

# if nvim is installed, use that
(( $+commands[nvim] )) && {
  export EDITOR="nvim"
}

export GIT_EDITOR=$EDITOR

unset VISUAL
