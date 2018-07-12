export NVM_DIR="$HOME/.nvm"

alias npmp="npm --always-auth false --registry https://registry.npmjs.com"

npms() {
  npm search --registry=https://registry.npmjs.org "$@"
}

# Load nvm
[[ -s "$NVM_DIR/nvm.sh" ]] && {
  source $NVM_DIR/nvm.sh
}
