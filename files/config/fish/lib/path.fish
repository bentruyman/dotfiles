# macOS uses path_helper to add other paths from other apps
set -l path_helper_output (eval /usr/libexec/path_helper -s)

# Parse the bourne shell formatted output and update PATH and MANPATH
for line in $path_helper_output
    if string match -qr "^PATH=" $line
        set -gx PATH (string replace -r "^PATH=\"(.*)\";" '$1' $line | string split ":")
    else if string match -qr "^MANPATH=" $line
        set -gx MANPATH (string replace -r "^MANPATH=\"(.*)\";" '$1' $line | string split ":")
    end
end

fish_add_path -g \
    $HOME/.bin \
    /opt/homebrew/bin \
    /usr/local/sbin /usr/local/bin \
    /usr/sbin /usr/bin \
    /sbin /bin
