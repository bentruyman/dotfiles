# fnm
_::path::prefix "${HOME}/.fnm"

(( $+commands[fnm] )) && {
  eval "`fnm env --multi`"
}

# shortcuts
alias npmp="npm --always-auth false --registry https://registry.npmjs.com"

npms() {
  npm search --registry=https://registry.npmjs.org "$@"
}

# yarn
_::path::prefix "${HOME}/.config/yarn/global/node_modules/.bin"
