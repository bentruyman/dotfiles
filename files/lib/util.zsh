_::path::prefix() {
  [[ ${path[(r)$1]} ]] || {
    [[ -d $1 ]] && path=($1 $path)
  }
}

_::path::suffix() {
  [[ ${path[(r)$1]} ]] || {
    [[ -d $1 ]] && path=($path $1)
  }
}

_::command_exists() {
  local command="$1"
  (( $+commands[$command] ))
}

_::env::is_macos() {
  [[ $(uname -s) = 'Darwin' ]]
}

_::env::is_ubuntu() {
  [[ "$(cat /etc/lsb-release 2> /dev/null | head -1 2> /dev/null)" =~ Ubuntu ]]
}
