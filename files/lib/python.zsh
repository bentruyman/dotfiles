_::path::prefix "${HOME}/miniconda3/bin"

(($+commands[pyenv])) && {
  if command -v pyenv >/dev/null; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
  fi
}
