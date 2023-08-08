function _::env::is_macos
    if test (uname -s) = Darwin
        return 0
    end
    return 1
end

function _::env::is_ubuntu
    # if string match -q "Ubuntu*" (cat /etc/lsb-release ^/dev/null | head -1 ^/dev/null)
    #     return 0
    # end
    return 1
end
