#!/bin/bash
Usage() {
    Usage_simple
    echo -e \
"    Options:
        teleport  : teleport to a spawnpoint (argument: optional)
        set       : set a spawnpoint (argument: optional)
        remove    : remove a spawnpoint (argument: required)
        clear     : clear all spawnpoints (argument: ignored)
        list      : list all spawnpoints (argument: ignored)
        help      : show this help (argument: ignored)
    Arguments:
        <index>   : index of spawnpoint (usually a number)"
}
Usage_simple() {
    echo Usage: spawnpoints [OPTION] [ARGUMENT]
}

# Check if file exists
if [ ! -f "$SPAWNPOINTS_FILE" ]; then
    echo "File not found! Creating..."
    touch $SPAWNPOINTS_FILE
    echo $HOME > $SPAWNPOINTS_FILE
fi

case $1 in
    teleport | tp )
        echo 'Abandoned feature';;
    set)
        if [ -z "$2" ]; then
            target=1
        else
            target=$2
        fi
        echo "Setting spawnpoint to index: $target... $(pwd)"
        sed -i -e $target"i"$(pwd) "$SPAWNPOINTS_FILE"
        ;;
    clear | clr )
        read -p "Are you sure you want to clear all spawnpoints? [y/N] " -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            echo "Clearing all spawnpoints..."
            echo $HOME > $SPAWNPOINTS_FILE
        else
            echo "Aborting..."
        fi
        ;;
    remove | rm)
        if [ -z "$2" ]; then
            echo "remove: missing operand"
            Usage
            exit 1
        fi
        # TODO: Implement remove by index
        goingtodelete=$(grep -n "$2" $SPAWNPOINTS_FILE | cut -d: -f1)
        is_number='^[0-9]+$'
        if ! [[ $2 =~ $is_number ]]; then
            echo "Error: $2 is not a number"
            exit 1
        fi
        echo "Removing spawnpoint $2..."
        sed -i -e $2"d" "$SPAWNPOINTS_FILE"
        ;;
    list | ls)
        cat "$SPAWNPOINTS_FILE" | nl
        ;;
    *help | -h)
        Usage
        exit 0
        ;;
    *)
        echo "Invalid option!"
        Usage
        exit 1
        ;;
esac

# check file has no empty lines
sed -i '/^$/d' $SPAWNPOINTS_FILE

# check file has no duplicate lines
sort -u $SPAWNPOINTS_FILE -o $SPAWNPOINTS_FILE 

# check character count of file
if [ $(wc -c < $SPAWNPOINTS_FILE) -eq 0 ]; then
    echo "File is empty! Creating..."
    echo $HOME > $SPAWNPOINTS_FILE
fi