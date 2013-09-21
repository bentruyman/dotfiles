# Git shortcuts
alias g "git"
alias clone "g clone"
alias ga "git add -A"
alias gb 'git branch'
alias gba 'git branch -a'
alias gc "git commit -v"
alias gcd 'git rev-parse 2>/dev/null and cd "./(git rev-parse --show-cdup)"'
alias gcl 'git config --list'
alias gclean 'git reset --hard and git clean -dfx'
alias gcm "git commit -m"
alias gcp 'git cherry-pick'
alias gd "git diff"
alias gdc 'gd --cached'
alias ggpull 'git pull origin $current_branch'
alias ggpush 'git push origin $current_branch'
alias gl 'git log'
alias gm 'git merge'
alias gp 'git push'
alias gpa 'gp --all'
alias gr "git remote"
alias grh 'git reset HEAD'
alias grhh 'git reset HEAD --hard'
alias grr 'git remote rm'
alias grv "gr -v"
alias gs 'git status'
alias gst 'gs'
alias gsu "git submodule update --init"
alias gu 'git pull'
alias gup='git pull --rebase'
alias gwc 'git whatchanged -p --abbrev-commit --pretty=medium'

# Shows files changed for a given path (gfc master..release)
alias gfc "git diff-tree --no-commit-id --name-only -r"

# Shorter more useful log
alias glog 'git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --'
