function cw --description "Set up a tmux worktree workspace"
    if test (count $argv) -ne 1
        echo "Usage: cw <worktree>"
        return 1
    end

    set -l worktree $argv[1]
    set -l worktree_dir .claude/worktrees/$worktree

    if not test -d $worktree_dir
        echo "Creating worktree: $worktree_dir"
        git worktree add -b worktree-$worktree $worktree_dir
        or return 1
    end

    if not set -q TMUX
        echo "Not inside a tmux session"
        return 1
    end

    set -l abs_dir (realpath $worktree_dir)

    set -l install_cmd ""
    if test -f $abs_dir/bun.lock
        set install_cmd "bun install"
    else if test -f $abs_dir/package-lock.json
        set install_cmd "npm install"
    end

    tmux rename-window $worktree
    tmux send-keys "cd $abs_dir && nvim" Enter
    tmux split-window -h -l 40% -c $abs_dir
    tmux send-keys "claude -w $worktree" Enter
    tmux split-window -v -l 30% -c $abs_dir
    if test -n "$install_cmd"
        tmux send-keys "$install_cmd" Enter
    end
    tmux select-pane -L
end
