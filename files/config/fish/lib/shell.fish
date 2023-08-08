# disable fish greeting
set fish_greeting

if type -q bat
    set -gx BAT_THEME "OneHalfDark"
end

if type -q kitty
    alias icat="kitty +kitten icat --align=left"
end

if type -q lsd
    alias ls=lsd
end
