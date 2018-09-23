_::env::is_macos && {
  export BROWSER="open"

  _::command_exists direnv && {
    eval "$(direnv hook zsh)"
  }

  alias brewup="brew update && brew upgrade"
  alias dsstore="find . -name \"*.DS_Store\" -type f -ls -delete"
  alias o="open ."
}
