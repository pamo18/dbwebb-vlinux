#!/usr/bin/env bash
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

# Save to file
SAVE=false



#
# Message to display for usage and help.
#
function usage
{
    local txt=(
""
"Server Utility $SCRIPT for vlinux kmom04."
"Usage: $SCRIPT [options] <command> [arguments]"
""
"Command:"
"  all                    All JSON items"
"  names                  Names of all the plants"
"  color [color]          All plants with a specific <color>"
"  test [url]             Test the default url or a specific <url>"
""
"Options:"
"  --help,    -h          Print help."
"  --version, -v          Print version."
"  --save,    -s          Save the returned data to 'client/saved.data'"
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
# All JSON items
#
function app-all
{
    url="http://localhost:1337/all"

    if $SAVE
    then
        curl $url -o "saved.data"
        curl $url
        echo ""
        echo ""
        echo "Data saved."
        echo ""
    else
        curl $url
        echo ""
    fi
}



#
# Names of all the plants
#
function app-names
{
    url="http://localhost:1337/names"

    if $SAVE
    then
        curl $url -o "saved.data"
        curl $url
        echo ""
        echo ""
        echo "Data saved."
        echo ""
    else
        curl $url
        echo ""
    fi
}



#
# All plants with a specific <color>
#
function app-color
{
    if [[ -n $1 ]]
    then
        url="http://localhost:1337/color/$1"
    else
        badUsage
        exit 1
    fi

    if $SAVE
    then
        curl "$url" -o "saved.data"
        curl "$url"
        echo ""
        echo ""
        echo "Data saved."
        echo ""
    else
        curl "$url"
        echo ""
    fi
}



#
# Test the default url or a specific <url>
#
function app-test
{
    if [[ -n $1 ]]
    then
        url="$1"
    else
        url="http://localhost:1337"
    fi

    if curl --output /dev/null --silent --head --fail "$url"
    then
        msg="Yes, $url is active."
        if $SAVE
        then
            echo "$msg" > "saved.data"
            echo "$msg"
            echo ""
            echo "Message saved."
            echo ""
        else
            echo "$msg"
        fi
    else
        msg="No, $url is not active."
        if $SAVE
        then
            echo "$msg" > "saved.data"
            echo "$msg"
            echo ""
            echo "Message saved."
            echo ""
        else
            echo "$msg"
        fi
    fi
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

        --save | -s)
            SAVE=true
            shift
        ;;

        test         \
        | color   \
        | names  \
        | all)
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
