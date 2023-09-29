alias g git
alias ga "git add -Av"
alias gc "git commit"
alias gco "git checkout"
alias gd "git diff"
alias gdc "git diff --cached"
alias gfr "git pull --rebase"
alias gl "git log"
alias gp "git push"
alias gpc 'git push --set-upstream origin "$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"'
alias gpf "git push --force"
alias gs "git stash"
alias gsp "git stash pop"
alias gst "git status"

function gpc
    git push --set-upstream origin "$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
end
