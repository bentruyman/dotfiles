_::env::is_macos && {
  export BROWSER="open"

  _::command_exists direnv && {
    eval "$(direnv hook zsh)"
  }
}
