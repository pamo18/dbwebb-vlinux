#!/usr/bin/env bash
# shellcheck disable=SC2015
#
# Pamo18
#
# Exit values:
#  0 on success
#  1 on failure
#



# Name of the script
SCRIPT=$( basename "$0" )

# Current version
VERSION="1.0.0"



#
# Message to display for usage and help.
#
function usage
{
    local txt=(
""
"Utility $SCRIPT for vlinux kmom05."
"Usage: $SCRIPT [options] <command> [arguments]"
""
"Command:"
"  start          Starts the client and server on port 8080."
"  stop           Stops and removes the server, client and network."
""
"Options:"
"  --help, -h     Print help."
"  --version, -h  Print version."
    )

    printf "%s\n" "${txt[@]}"
}



#
# Message to display when bad usage.
#
function badUsage
{
    local message="$1"
    local txt=(
"For an overview of the command, execute:"
"$SCRIPT --help"
    )

    [[ -n $message ]] && printf "%s\n" "$message"

    printf "%s\n" "${txt[@]}"
}



#
# Message to display for version.
#
function version
{
    local txt=(
"$SCRIPT version $VERSION"
    )

    printf "%s\n" "${txt[@]}"
}



#
# Starts the client and server on port 8080
#
function app-start
{
    docker network create dbwebb
    docker run -d -p 8080:1337 --name mazeserver --net dbwebb pamo18/vlinux-mazeserver:latest
    docker run -it --name mazeclient --net dbwebb --link mazeserver:mazeserver pamo18/vlinux-mazeclient:latest
}

#
# Stops and removes the server, client and network
#
function app-stop
{
    docker stop mazeclient || true && docker rm mazeclient || true
    docker stop mazeserver || true && docker rm mazeserver || true
    docker network rm dbwebb
    echo -e "\nThe Network dbwebb and all containers have now been stopped and removed\n"
}



#
# Process options
#
while (( $# ))
do
    case "$1" in

        --help | -h)
            usage
            exit 0
        ;;

        --version | -v)
            version
            exit 0
        ;;

        start         \
        | stop)
            command=$1
            shift
            app-"$command" "$@"
            exit 0
        ;;

        *)
            badUsage "Option/command not recognized."
            exit 1
        ;;

    esac
done

badUsage
exit 1
