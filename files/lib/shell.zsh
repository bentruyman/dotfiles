setopt null_glob # Don't complain about empty globs
setopt auto_cd # cd without cd
setopt extended_glob # Enable extended globs
setopt rmstarsilent # Don't ask for confirmation on `rm *`

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

(( $+commands[kitty] )) && {
  alias icat="kitty +kitten icat --align=left"
}

(( $+commands[lsd] )) && {
  alias ls=lsd
}

