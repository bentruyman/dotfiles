function cw --description "Set up a tmux worktree workspace"
    if test (count $argv) -ne 1
        echo "Usage: cw <worktree>"
        return 1
    end

    set -l worktree $argv[1]
    set -l worktree_dir .claude/worktrees/$worktree

    if not test -d $worktree_dir
        echo "Worktree not found: $worktree_dir"
        return 1
    end

    if not set -q TMUX
        echo "Not inside a tmux session"
        return 1
    end

    set -l abs_dir (realpath $worktree_dir)

    tmux send-keys "cd $abs_dir && nvim" Enter
    tmux split-window -h -l 40% -c $abs_dir
    tmux send-keys "claude -w $worktree" Enter
    tmux split-window -v -l 30% -c $abs_dir
    tmux select-pane -L
end
