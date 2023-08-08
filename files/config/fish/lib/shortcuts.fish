# Filesystem
function md
    mkdir -p $argv[1]
    cd $argv[1] || exit
end

# Navigation
alias ... "cd ../.."
alias .... "cd ../../.."
alias l "ls -al"
alias j z

# Coding
if type -q prettier
    alias pretty "prettier --write '**/*.{js,json,md,scss,ts,vue}'"
end
