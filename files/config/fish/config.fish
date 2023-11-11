set fish_greeting

# Deno
set -gx DENO_INSTALL $HOME/.deno
fish_add_path $DENO_INSTALL/bin

# Docker
if type -q docker
    function dclean
        docker rm -v (docker ps --filter status=exited -q 2> /dev/null) 2>/dev/null
        docker rmi (docker images --filter dangling=true -q 2> /dev/null) 2>/dev/null
    end

    function dshell
        if test -z "$argv[1]"
            echo "An image name must be specified"
            return 1
        end
        docker run --rm -it $argv[1] sh
    end
end

# Editor
if type -q nvim
    set -gx EDITOR nvim
end

set -gx GIT_EDITOR $EDITOR

# Git
alias g git
alias ga "git add -Av"
alias gc "git commit"
alias gco "git checkout"
alias gd "git diff"
alias gdc "git diff --cached"
alias gfr "git pull --rebase"
alias gl "git log"
alias gp "git push"
alias gpf "git push --force"
alias gs "git stash"
alias gsp "git stash pop"
alias gst "git status"

function gpc
    git push --set-upstream origin "$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
end

# GPG
set -gx GPG_TTY (tty)

# Local RC
set rc_dir $HOME/.rc

if test -d $rc_dir
    for file in $rc_dir/*.fish
        source $file
    end
end

# macOS
set -gx BROWSER open

alias brewup "brew update && brew upgrade"
alias dsstore "find . -name \"*.DS_Store\" -type f -ls -delete"
alias o "open ."

# Node.js
alias npj "nice-package-json --write"

if test -e "$HOME/.volta"
    set -gx VOLTA_HOME "$HOME/.volta"
    fish_add_path $VOLTA_HOME/bin
end

# Path
set -l path_helper_output (eval /usr/libexec/path_helper -s)

for line in $path_helper_output
    if string match -qr "^PATH=" $line
        set -gx PATH (string replace -r "^PATH=\"(.*)\";" '$1' $line | string split ":")
    else if string match -qr "^MANPATH=" $line
        set -gx MANPATH (string replace -r "^MANPATH=\"(.*)\";" '$1' $line | string split ":")
    end
end

fish_add_path -g \
    $HOME/.bin \
    /opt/homebrew/bin \
    /usr/local/sbin /usr/local/bin \
    /usr/sbin /usr/bin \
    /sbin /bin

# Rust
fish_add_path $HOME/.cargo/bin

# Shell
if type -q bat
    set -gx BAT_THEME OneHalfDark
end

if type -q kitty
    alias icat="kitty +kitten icat --align=left"
end

if type -q lsd
    alias ls=lsd
end

# Shortcuts
function md
    mkdir -p $argv[1]
    cd $argv[1] || exit
end

alias ... "cd ../.."
alias .... "cd ../../.."
alias l "ls -al"
alias j z

if type -q prettier
    alias pretty "prettier --write '**/*.{js,json,md,scss,ts,vue}'"
end

# tmux
if type -q tmux
    alias tma "tmux attach -d -t"
    alias tmk "tmux kill-session -t"
    alias tml "tmux list-sessions"

    function tmx
        # If first argument is not empty, use it. Otherwise, use the name of the current directory.
        if test -n "$argv[1]"
            set name $argv[1]
        else
            set name (basename $PWD | string replace -r '^\.' '')
        end

        echo $name
        tmux attach -t $name || tmux new -s $name
    end
end
