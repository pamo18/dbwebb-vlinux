#!/usr/bin/env bash
# shellcheck disable=SC2034,SC2162
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

# Server URL
# URL="http://localhost:1337"
URL="http://mazeserver:1337"

# Get results as csv instead of JSON
CSV="?type=csv"

# File for saving game details
FILE="saved.csv"


#
# Message to display for usage and help.
#
function usage
{
    local txt=(
""
"Server Utility $SCRIPT for vlinux kmom05."
"Usage: $SCRIPT [options] <command> [arguments]"
""
"Command:"
"  init                 Initialize the maze"
"  maps                 list all available maps"
"  select [#map]        select map as the current maze"
"  enter                Enter the maze and get the contents of the first room"
"  info                 Get info about the room"
"  go north             Walk away from the current room and go north"
"  go south             Walk away from the current room and go south"
"  go east              Walk away from the current room and go east"
"  go west              Walk away from the current room and go west"
"  loop                 init the game, choose a map and start a game loop"
""
"Options:"
"  --help,    -h        Print help."
"  --version, -v        Print version."
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
# Get current game details
#
function restoreGame
{
    while IFS=',' read -r text value
    do
        if [[ "$text" = "id" ]];
        then
            ID="$value"
        elif [[ "$text" = "room" ]];
        then
            ROOM="$value"
        fi
    done < "$FILE"
}



#
# Save current game id and/or room to file
#
function save
{
    if [[ -n $1 && -n $2 ]]
    then
        echo -e "id,$1\nroom,$2" > $FILE
    elif [[ -n $1 ]]
    then
        echo -e "id,$1" > $FILE
    fi
}



#
# Init a new game
#
function app-init
{
    init=$(curl -s "$URL/$CSV" | tail -1)

    while IFS=',' read -r text gameid
    do
        echo -e "\n$text\n"
        echo -e "Your game ID is: $gameid\n"
        save "$gameid"
    done <<< "${init}"
}



#
# Show all available maps
#
function app-maps
{
    maps=$(curl -s "$URL/map/$CSV" | tail -1)

    while IFS=',' read -r m1 m2
    do
        echo -e "1) $m1"
        echo -e "2) $m2\n"
    done <<< "${maps}"
}



#
# Select chosen map
#
function app-select
{
    restoreGame
    m1="maze-of-doom"
    m2="small-maze"

    if [[ -n $1 ]]
    then
        if [[ $1 = "1" ]]
        then
            select=$m1
        elif [[ $1 = "2" ]]
        then
            select=$m2
        fi

        if [[ -n $select ]]
        then
            echo ""
            curl -s "$URL/$ID/map/$select$CSV" | tail -1
            echo ""
        else
            echo -e "\nPlease choose map #1 or #2.\n"
        fi
    else
        badUsage
        exit 1
    fi
}



#
# Enter the maze
#
function app-enter
{
    restoreGame
    res=$(curl -s "$URL/$ID/maze$CSV" | tail -1)

    while IFS=',' read -r ro de we ea so no ex
    do
        if [[ $ro -eq 0 ]]
        then
            ROOM="0"
        else
            ROOM=$ro
        fi
        break
    done <<< "$res"

    save "$ID" "$ROOM"
    app-info "$ID" "$ROOM"
}



#
# Leave the current room and go in the chosen direction
#
function app-go
{
    if [[ $1 = "exit" || $1 = "Exit" || $1 = "Quit" || $1 = "quit" ]]
    then
        echo -e "\nNobody likes a quitter!\n"
        exit 0
    fi

    restoreGame
    if [[ -n $ID && -n $ROOM && -n $1 ]]
    then
        case "$1" in
            north)
                res=$(curl -s "$URL/$ID/maze/$ROOM/north$CSV" | tail -1)
            ;;

            south)
                res=$(curl -s "$URL/$ID/maze/$ROOM/south$CSV" | tail -1)
            ;;

            east)
                res=$(curl -s "$URL/$ID/maze/$ROOM/east$CSV" | tail -1)
            ;;

            west)
                res=$(curl -s "$URL/$ID/maze/$ROOM/west$CSV" | tail -1)
            ;;

            *)
                res="invalid"
            ;;
        esac
    else
        badUsage
        exit 1
    fi

    if [[ ! "$res" = "invalid" ]]
    then
        while IFS=',' read -r room desc west east south north exists
        do
            if [[ "$desc" = "You found the exit" ]]
            then
                echo -e "\n$desc, please start a new game!\n"
                exit 0
            elif [[ "$ROOM" = "$room" ]]
            then
                echo -e "\n$exists\n"
            else
                ROOM=$room
                save "$ID" "$ROOM"
                app-info "$ID" "$ROOM"
            fi
        done <<< "${res}"
    else
        echo -e "\nInvalid path!\n"
    fi
}



#
# Shows room info
#
function app-info
{
    if [[ -n $1 && -n $2 ]]
    then
        res=$(curl -s "$URL/$1/maze/$2$CSV" | tail -1)
    else
        restoreGame
        if [[ -n $ID && -n $ROOM ]]
        then
            res=$(curl -s "$URL/$ID/maze/$ROOM$CSV" | tail -1)
        else
            badUsage
            exit 1
        fi
    fi

    go="You can go"

    while IFS=',' read -r room desc west east south north exists
    do
        echo -e "\nYou are in room: $room"
        echo -e "Description: $desc\n"
        if [[ ! "$west" = "-" ]]
        then
            echo "$go west to room $west"
        fi

        if [[ ! "$east" = "-" ]]
        then
            echo "$go east to room $east"
        fi

        if [[ ! "$south" = "-" ]]
        then
            echo "$go south to room $south"
        fi

        if [[ ! "$north" = "-" ]]
        then
            echo "$go north to room $north"
        fi
        echo ""

    done <<< "${res}"
}

#
# Loop the game
#
function app-loop
{
    app-init
    app-maps
    while true
    do
        read -n 1 -p "Map Selection: " user
        if [[ $user = "1" || $user = "2" ]]
        then
            app-select "$user"
            break
        else
            echo -e "\n\nSelect maze 1 or 2 only!\n"
        fi
    done

    echo -e "Type 'exit or 'quit' to end the game'"
    app-enter

    while true
    do
        read -p "Which direction do you want to go? " user
        app-go "$user"
    done
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

        init         \
        | maps    \
        | select  \
        | enter   \
        | info    \
        | go      \
        | loop)
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
