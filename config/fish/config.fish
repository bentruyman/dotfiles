#
# If issues occur with $PATH not being in the expected order, check the
# `fish_variables` file for the `fish_user_paths` variable.
#

set fish_greeting

# Deno
set -gx DENO_INSTALL $HOME/.deno
fish_add_path $DENO_INSTALL/bin
alias dr "deno run -A"

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

# Git
alias g git
alias ga "git add -Av"
alias gc "git commit"
alias gco "git checkout"
alias gd "git diff"
alias gdc "git diff --cached"
alias gf "git show --pretty="" --name-only"
alias gfr "git pull --rebase"
alias gl "git log"
alias gp "git push"
alias gpf "git push --force"
alias gs "git stash"
alias gsp "git stash pop"
alias gst "git status"

function clone -d "Quickly clone git repos in a conventional way"
    set -l url $argv[1]

    # Validate the URL format
    if not string match -qr '^(https://|git@)([^:/]+)[/:](.*)\.git$' -- $url
        echo "Invalid repository URL: $url"
        echo "Please provide a valid git repository URL."
        return 1
    end

    set -l repo_dir (string replace -r '^(https://|git@)([^:/]+)[/:](.*)\.git$' '$2/$3' -- $url)
    set -l target_dir "$HOME/Development/src/$repo_dir"

    if not test -d "$target_dir"
        mkdir -p "$target_dir"
        git clone "$url" "$target_dir"
    else
        echo "Directory $target_dir already exists."
    end

    cd $target_dir
end

function gpc
    git push --set-upstream origin "$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
end

# Godot
set GODOT_CLI "/Applications/Godot.app/Contents/MacOS/Godot"
if test -f $GODOT_CLI
    alias godot $GODOT_CLI
    alias gut 'godot --debug-collisions --path $PWD -d -s addons/gut/gut_cmdln.gd'
end

# Golang
set -gx GOPATH $HOME/Development
set -gx GOBIN $GOPATH/bin
set -gx PATH $GOBIN $PATH

# GPG
set -gx GPG_TTY (tty)

# Local Scripts
set local_scripts $HOME/.dotfiles/fish

if test -d $local_scripts
    for file in $local_scripts/*.fish
        source $file
    end
end

# LLVM
fish_add_path /opt/homebrew/opt/llvm/bin

# macOS
set -gx BROWSER open

alias brewup "brew update && brew upgrade"
alias dsstore "find . -name \"*.DS_Store\" -type f -ls -delete"
alias o "open ."

# Node.js
alias npj "nice-package-json --write"

if test -e "$HOME/.volta"
    set -gx VOLTA_HOME "$HOME/.volta"
    set -gx VOLTA_FEATURE_PNPM 1
    fish_add_path $VOLTA_HOME/bin
end
set -gx NEXT_TELEMETRY_DISABLED 1 # Disable Next.js telemetry

# Path
fish_add_path -a \
    "$HOME/.bin" \
    /opt/homebrew/bin /opt/homebrew/sbin \
    /usr/local/bin /usr/local/sbin \
    /usr/bin /usr/sbin \
    /bin /sbin

# Rust
fish_add_path $HOME/.cargo/bin

# Shell
if type -q bat
    set -gx BAT_THEME Catppuccin-mocha
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
        if test -n "$argv[1]"
            set name $argv[1]
        else
            set name (basename $PWD | string replace -r '^\.' '')
        end

        echo $name
        tmux attach -t $name || tmux new -s $name
    end
end

# webstorm
fish_add_path /Applications/WebStorm.app/Contents/MacOS

# Added by Windsurf
fish_add_path /Users/bentruyman/.codeium/windsurf/bin
