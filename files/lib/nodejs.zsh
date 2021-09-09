# shortcuts
alias npmp="npm --always-auth false --registry https://registry.npmjs.com"

npms() {
  npm search --registry=https://registry.npmjs.org "$@"
}

# volta
export VOLTA_HOME="${HOME}/.volta"
_::path::prefix "${VOLTA_HOME}/bin"

# yarn
_::path::prefix "${HOME}/.config/yarn/global/node_modules/.bin"
