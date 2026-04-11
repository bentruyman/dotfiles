#
# If issues occur with $PATH not being in the expected order, check the
# `fish_variables` file for the `fish_user_paths` variable.
#

set fish_greeting

# `fish_add_path` defaults to mutating the universal `fish_user_paths`, which
# makes PATH ordering sticky across sessions. This config manages PATH directly,
# so clean up previously-managed universal entries before rebuilding PATH below.
if set -q fish_user_paths
    set -l managed_fish_user_paths \
        "$HOME/.proto/shims" \
        "$HOME/.proto/bin" \
        "$HOME/.proto/tools/node/globals/bin" \
        "$HOME/.cargo/bin" \
        "$HOME/.bun/bin" \
        "$HOME/.deno/bin" \
        "$HOME/.bin" \
        "$HOME/.local/bin" \
        /opt/homebrew/bin \
        /opt/homebrew/sbin \
        /usr/local/bin \
        /usr/local/sbin \
        /usr/bin \
        /usr/sbin \
        /bin \
        /sbin

    set -l remaining_fish_user_paths $fish_user_paths
    for managed_path in $managed_fish_user_paths
        set -l index (contains -i -- $managed_path $remaining_fish_user_paths)
        while test -n "$index"
            set -e remaining_fish_user_paths[$index]
            set index (contains -i -- $managed_path $remaining_fish_user_paths)
        end
    end

    if test (count $remaining_fish_user_paths) -gt 0
        set -U fish_user_paths $remaining_fish_user_paths
    else
        set -eU fish_user_paths
    end
end

# Prompt

# Remove kubectl from the right prompt if it's there
if set -l index (contains -i kubectl $tide_right_prompt_items)
  set -e tide_right_prompt_items[$index]
end

# bun
set --export BUN_INSTALL "$HOME/.bun"

# Deno
set -gx DENO_INSTALL $HOME/.deno
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

function gcb
  set local_branches (git branch | string trim | string replace -r '^\* ' '')
  set remote_branches (git branch -r | string trim | string replace -r '^origin/' '' | sort -u)
  for branch in $local_branches
    if contains -- $branch main master
      continue
    end
    if not contains -- $branch $remote_branches
      git branch -D $branch
    end
  end
end

function gpc
    git push --set-upstream origin "$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
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

# macOS
set -gx BROWSER open

alias brewup "brew update && brew upgrade"
alias dsstore "find . -name \"*.DS_Store\" -type f -ls -delete"
alias o "open ."

# Node.js
alias npj "nice-package-json --write"

set -gx NEXT_TELEMETRY_DISABLED 1 # Disable Next.js telemetry

# proto
if test -e "$HOME/.proto"
  set -gx PROTO_HOME "$HOME/.proto";

  fish_add_path -g \
    "$PROTO_HOME/shims" \
    "$PROTO_HOME/bin" \
    "$PROTO_HOME/tools/node/globals/bin" \
    "$PROTO_HOME/tools/python/*/bin"

  fish_add_path -g "$PROTO_HOME/bin" \

  proto activate fish | source
end

# Path
fish_add_path -g -a \
    "$HOME/.bin" \
    "$HOME/.local/bin" \
    /opt/homebrew/bin /opt/homebrew/sbin \
    /usr/local/bin /usr/local/sbin \
    /usr/bin /usr/sbin \
    /bin /sbin

# Shell
if type -q bat
    set -gx BAT_THEME Catppuccin-mocha
end

if type -q lsd
    alias ls=lsd
end

# Shortcuts
function cwd
    pwd | pbcopy
end

function mkd
    mkdir -p $argv[1]
    cd $argv[1] || exit
end

alias ... "cd ../.."
alias .... "cd ../../.."
alias l "ls -al"
alias j z

if type -q kubectl
    alias k "kubectl"
end

if type -q mods && type -q zig
    alias modz "mods --role zig"
end

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
