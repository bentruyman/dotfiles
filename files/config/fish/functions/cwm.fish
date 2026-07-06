function cwm --description "Merge a worktree branch into the default branch, then prune it"
    if test (count $argv) -gt 1
        echo "Usage: cwm [<worktree>]"
        return 1
    end

    # Resolve the branch to finish: from the argument or the current HEAD.
    set -l branch
    if test (count $argv) -eq 1
        set branch worktree-$argv[1]
    else
        set branch (git rev-parse --abbrev-ref HEAD)
        or return 1
    end

    # Determine the default branch (mirrors git-done).
    set -l default_branch (git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/origin/||')
    test -n "$default_branch"; or set default_branch main

    if test "$branch" = "$default_branch"
        echo "cwm: refusing to merge the default branch ('$default_branch') into itself"
        return 1
    end

    # Map worktrees to directories: main_dir is the primary worktree (listed
    # first), target_dir is the one checked out on $branch.
    set -l main_dir ""
    set -l target_dir ""
    set -l pending_dir ""
    for line in (git worktree list --porcelain)
        set -l dir (string replace -r '^worktree ' '' -- $line)
        if test "$dir" != "$line"
            set pending_dir $dir
            test -n "$main_dir"; or set main_dir $dir
            continue
        end
        set -l ref (string replace -r '^branch refs/heads/' '' -- $line)
        if test "$ref" != "$line"; and test "$ref" = "$branch"
            set target_dir $pending_dir
        end
    end

    if test -z "$target_dir"
        echo "cwm: no worktree checked out on branch '$branch'"
        return 1
    end

    if test "$target_dir" = "$main_dir"
        echo "cwm: '$branch' is the primary worktree; run this from a worktree created with cw"
        return 1
    end

    # Refuse to proceed if the worktree has uncommitted changes.
    set -l dirty (git -C $target_dir status --porcelain)
    if test -n "$dirty"
        echo "cwm: worktree at $target_dir has uncommitted changes; commit or stash first"
        return 1
    end

    # Identify the tmux window `cw` set up for this worktree so we can close it
    # after pruning. Match by a pane whose path is inside the target worktree;
    # this works whether cwm runs from that tab or from another one.
    set -l worktree_window ""
    if set -q TMUX
        set -l target_real (realpath $target_dir)
        for line in (tmux list-panes -a -F '#{window_id} #{pane_current_path}')
            set -l parts (string split ' ' -- $line)
            set -l wid $parts[1]
            set -l ppath (string join ' ' $parts[2..-1])
            set -l ppath_real (realpath $ppath 2>/dev/null)
            if test "$ppath_real" = "$target_real"; or string match -q -- "$target_real/*" "$ppath_real"
                set worktree_window $wid
                break
            end
        end
    end

    # Move to the primary worktree so we can prune the one we came from.
    cd $main_dir
    or return 1

    set -l main_branch (git rev-parse --abbrev-ref HEAD)
    if test "$main_branch" != "$default_branch"
        git checkout $default_branch
        or return 1
    end

    # Fast-forward the default branch to its upstream first, if it tracks one.
    if git rev-parse --abbrev-ref '@{upstream}' >/dev/null 2>&1
        git pull --ff-only
        or return 1
    end

    # Rebase the feature branch onto the updated default branch so the merge can
    # fast-forward (this setup uses merge.ff = only). The rebase runs in the
    # feature worktree, since that is where $branch is checked out.
    echo "Rebasing $branch onto $default_branch"
    if not git -C $target_dir rebase $default_branch
        git -C $target_dir rebase --abort
        echo "cwm: rebase hit conflicts; resolve them in $target_dir, then rerun cwm"
        echo "     cd $target_dir; and git rebase $default_branch"
        return 1
    end

    echo "Merging $branch into $default_branch"
    git merge --ff-only $branch
    or return 1

    echo "Removing worktree: $target_dir"
    git worktree remove $target_dir
    or return 1

    echo "Deleting branch: $branch"
    git branch -d $branch
    or return 1

    # Close the tmux tab cw created for this worktree. This kills the pane
    # running cwm if it lives in that window, so keep it as the final step.
    if test -n "$worktree_window"
        tmux kill-window -t $worktree_window
    end
end
