(( $+commands[fnm] )) && {
  eval "`fnm env --multi`"
}

alias npmp="npm --always-auth false --registry https://registry.npmjs.com"

npms() {
  npm search --registry=https://registry.npmjs.org "$@"
}
