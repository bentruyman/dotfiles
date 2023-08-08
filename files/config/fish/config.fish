if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_greeting
set -gx DOTFILES_LIB (dirname (status --current-filename))/lib
source $DOTFILES_LIB/init.fish
