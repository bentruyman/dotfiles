set fish_greeting
set -gx DOTFILES_LIB (dirname (status --current-filename))/lib
source $DOTFILES_LIB/init.fish
