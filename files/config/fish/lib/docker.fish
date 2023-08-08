# Check if 'docker' command exists
if type -q docker
    function dclean
        # Remove exited containers
        docker rm -v (docker ps --filter status=exited -q 2> /dev/null) 2>/dev/null
        # Remove dangling images
        docker rmi (docker images --filter dangling=true -q 2> /dev/null) 2>/dev/null
    end

    function alpine
        docker run --rm -it bentruyman/alpine $argv
    end

    function dshell
        if test -z "$argv[1]"
            echo "An image name must be specified"
            return 1
        end
        docker run --rm -it $argv[1] sh
    end
end
