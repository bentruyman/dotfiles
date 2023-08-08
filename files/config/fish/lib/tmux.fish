# Check if 'tmux' command exists
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
