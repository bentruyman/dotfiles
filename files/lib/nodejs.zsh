# shortcuts
alias npj="nice-package-json --write"
alias npmp="npm --always-auth false --registry https://registry.npmjs.com"

npms() {
  npm search --registry=https://registry.npmjs.org "$@"
}

# bun
[ -s "/Users/bentruyman/.bun/_bun" ] && source "/Users/bentruyman/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
_::path::prefix "${BUN_INSTALL}/bin"

# volta
export VOLTA_HOME="${HOME}/.volta"
_::path::prefix "${VOLTA_HOME}/bin"

# yarn
_::path::prefix "${HOME}/.config/yarn/global/node_modules/.bin"
