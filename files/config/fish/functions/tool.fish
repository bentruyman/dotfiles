function tool --description "Create a cross-shell wrapper script in ~/.local/bin"
    if test (count $argv) -lt 2
        echo "Usage: tool <name> <command> [args...]" >&2
        return 1
    end

    set name $argv[1]
    set cmd (string join ' ' $argv[2..])
    set target ~/.local/bin/$name

    mkdir -p ~/.local/bin
    printf '#!/usr/bin/env sh\nexec %s "$@"\n' $cmd >$target
    chmod +x $target
    echo "Created $target"
end
