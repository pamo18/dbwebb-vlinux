#!/usr/bin/env bash
# shellcheck disable=SC2034,SC2162,SC2015
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

# Server file
FILE="server.txt"

# Server URL
SERVER=$(cat "$FILE")

URL="http://$SERVER:1337"



#
# Message to display for usage and help.
#
function usage
{
    local txt=(
""
"BTH Server & Nätverk AB"
"Client $SCRIPT for vlinux kmom10."
"Usage: $SCRIPT [options] <command> [arguments]"
""
"Commands available:"
"  url                               Get url to view the server in browser."
"  view                              List all entries."
"  view url <url>                    View all entries containing <url>."
"  view ip <ip>                      View all entries containing <ip>."
"  view time <time>                  View all entries containing <time>"
"  view day <day>                    View all entries containing <day>"
"  view day <day> <time>             View all entries containing <day> <time>"
"  view month <month>                View all entries containing <month>"
"  view month <month> <day> <time>   View all entries containing <month> <day> <time>"
"  use <server>                      Set the servername (localhost or service name)."
""
"Options available:"
"  -h, --help           Display the menu."
"  -v, --version        Display the current version."
"  -c, --count          Display the number of rows returned"
""
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
# Get url
#
function app-url
{
    echo -e "\n$URL\n"
}



#
# Set server
#
function app-use
{
    echo "$1" > "$FILE"
}



#
# View the data
#
function app-view
{
    req="$URL/data"

    case "$1" in
        "")
            req+="/"
        ;;

        url)
            req+="?url=$2"
        ;;

        ip)
            req+="?ip=$2"
        ;;

        time)
            req+="?time=$2"
        ;;

        day)
            if [[ -n "$3" ]]
            then
                req+="?day=$2&time=$3"
            elif [[ -n "$2" ]]
            then
                req+="?day=$2"
            else
                badUsage
                exit 1
            fi
        ;;

        month)
            if [[ -n "$4" ]]
            then
                req+="?month=$2&day=$3&time=$4"
            elif [[ -n "$3" ]]
            then
                badUsage
                exit 1
            elif [[ -n "$2" ]]
            then
                req+="?month=$2"
            else
                badUsage
                exit 1
            fi
        ;;

        *)
            badUsage "Option/command not recognized."
            exit 1
        ;;

    esac

    res=$(curl -s "$req")
    ( [[ -n "$COUNT" ]] && echo "$res" | jq --tab . | jq length || echo "$res" | jq --tab . )
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

        --count | -c)
            COUNT=true
            shift
        ;;

        url         \
        | view    \
        | use)
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
