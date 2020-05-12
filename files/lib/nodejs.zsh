# shortcuts
alias npmp="npm --always-auth false --registry https://registry.npmjs.com"

npms() {
  npm search --registry=https://registry.npmjs.org "$@"
}

# deno
export DENO_INSTALL="${HOME}/.deno"
[[ -d "${DENO_INSTALL}" ]] && _::path::prefix "${DENO_INSTALL}/bin"

# volta
export VOLTA_HOME="${HOME}/.volta"
[[ -s "${VOLTA_HOME}/load.sh" ]] && . "${VOLTA_HOME}/load.sh"

_::path::prefix "${VOLTA_HOME}/bin"

# yarn
_::path::prefix "${HOME}/.config/yarn/global/node_modules/.bin"
