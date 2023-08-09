set rc_dir $HOME/.rc

if test -d $rc_dir
    for file in $rc_dir/*.fish
        source $file
    end
end
