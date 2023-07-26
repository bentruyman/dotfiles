(( $+commands[bat] )) && {
  export BAT_THEME="OneHalfDark"
}

(( $+commands[kitty] )) && {
  alias icat="kitty +kitten icat --align=left"
}

(( $+commands[lsd] )) && {
  alias ls=lsd
}
