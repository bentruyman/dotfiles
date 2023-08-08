if type -q nvim
    set -gx EDITOR nvim
end

set -gx GIT_EDITOR $EDITOR
