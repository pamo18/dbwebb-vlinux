#!/usr/bin/env bash
# shellcheck disable=SC2034
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

# Default log input file
INPUT="access-50k.log"

# Default log output file
OUTPUT="data/log.json"


#
# Message to display for usage and help.
#
function usage
{
    local txt=(
""
"Log to JSON conversion Utility $SCRIPT for vlinux kmom10."
"Usage: $SCRIPT [options] <command> [arguments]"
""
"Command:"
"  convert              Convert log file to JSON"
"  Count                Count number of row in the JSON file"
""
"Options:"
"  --help,    -h        Print help."
"  --version, -v        Print version."
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
# Convert log to JSON
#
function app-convert
{
    sed -n -E 's/^([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*\[([0-9]{2})\/([a-zA-Z]{3})\/([0-9]{4}):([0-9]{2}:[0-9]{2}:[0-9]{2}).*(http[s]?:\/\/[a-zA-Z0-9]+\.[a-zA-Z0-9]+\.?[a-zA-Z0-9]*\.?[a-zA-Z0-9]*).*/{"ip":"\1","url":"\6","day":"\2","month":"\3","year":"\4","time":"\5"}/p' < "$INPUT" | jq -s --tab . > "$OUTPUT"

    echo "Conversion complete!"
}



#
# Count JSON objects
#
function app-count
{
     length=$(jq '. | length' "$OUTPUT")

     echo "The number of objects in the JSON log file is: $length"
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

        convert \
        | count)
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
