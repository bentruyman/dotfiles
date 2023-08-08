# shortcuts
alias npj "nice-package-json --write"
alias npmp "npm --always-auth false --registry https://registry.npmjs.com"

function npms
    npm search --registry=https://registry.npmjs.org $argv
end

if test -e "$HOME/.bun/_bun"
    source "$HOME/.bun/_bun"
    set -gx BUN_INSTALL "$HOME/.bun"
    fish_add_path $BUN_INSTALL/bin
end

# volta
if test -e "$HOME/.volta"
    set -gx VOLTA_HOME "$HOME/.volta"
    fish_add_path $VOLTA_HOME/bin
end
