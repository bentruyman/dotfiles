_::import() {
  local script="$1"
  source "$DOTFILES_LIB/$script.zsh"
}

_::import "shell"
_::import "util"
_::import "path"

_::import "local"

_::import "deno"
_::import "docker"
_::import "editor"
_::import "fzf"
_::import "git"
_::import "gpg"
_::import "kubernetes"
_::import "python"
_::import "nodejs"
_::import "rust"
_::import "shortcuts"
_::import "tmux"

_::env::is_macos && _::import "macos"
_::env::is_ubuntu && _::import "ubuntu"

_::import "prompt"
