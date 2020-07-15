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



#
# Message to display for usage and help.
#
function usage
{
    local txt=(
""
"Utility $SCRIPT for vlinux kmom03."
"Usage: $SCRIPT [options] <command> [arguments]"
""
"Command:"
"  cal                        Prints a calendar"
"  greet                      Prints a welcome message"
"  loop [min] [max]           Prints numbers between <min> and <max>"
"  lower [n] [n] [n..]        Print out all numbers less than 42"
"  reverse [random sentence]  Prints a random sentence in reverse"
"  starwars                   runs 'telnet towel.blinkenlights.nl'"
"  all                        Runs all commands with default values"
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
# Prints a calendar
#
function app-cal
{
    echo ""
    echo "Here is the current calender."
    echo ""
    cal -3
}


#
# Prints a welcome message
#
function app-greet
{
    echo ""
    echo "Hello $USER, have a nice day.  Regards, Paul Moreland:)"
    echo ""
}


#
# Prints numbers between <min> and <max>
#
function app-loop
{
    min=$1
    max=$2
    if [[ $min -gt 0 ]] && [[ $max -gt 0 ]]
    then
        for (( i=min; i<=max; i++ ))
        do
            echo "$i"
        done
    else
        badUsage
        exit 1
    fi
}


#
# Print out all numbers less than 42
#
function app-lower
{
    if [[ $# -gt 0 ]]
    then
        for arg in "$@"
        do
            if [[ $arg -lt 42 ]] && [[ $arg -gt 0 ]]
            then
                echo "$arg"
            fi
        done
    else
        badUsage
        exit 1
    fi
}


#
# Starwars
#
function app-starwars
{
    telnet towel.blinkenlights.nl
}



#
# Prints a random sentence in reverse
#
function app-reverse
{
    if [[ $# -gt 0 ]]
    then
        echo "$*" | rev
    else
        badUsage
        exit 1
    fi
}


#
# Runs all commands with default values
#
function app-all
{
    app-cal
    echo ""
    echo "Greeting:"
    app-greet
    echo "Printing numbers between 1 and 10:"
    echo ""
    app-loop "1" "10"
    echo ""
    echo "Printing numbers less than 42 from: 1 42 40 39 100 10 5 41"
    echo ""
    app-lower "1" "42" "40" "39" "100" "10" "5" "41"
    echo ""
    echo "Printing 'random sentence' in reverse:"
    echo ""
    app-reverse "random sentence"
    echo ""
    echo "Good bye!"
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

        cal         \
        | greet     \
        | loop      \
        | lower     \
        | reverse   \
        | starwars  \
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
