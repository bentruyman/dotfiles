function _::import
    source $DOTFILES_LIB/$argv[1].fish
end

_::import shell
_::import util
_::import path

_::import local

_::import deno
_::import docker
_::import editor
_::import git
_::import gpg
_::import nodejs
_::import rust
_::import shortcuts
_::import tmux

if _::env::is_macos
    _::import macos
else if _::env::is_ubuntu
    _::import ubuntu
end
