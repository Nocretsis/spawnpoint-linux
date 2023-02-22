#!/bin/bash
__version__=0.1.0
is_number='^[0-9]+$'
Usage() {
    Usage_simple
    echo -e \
"    Options:
        teleport  : teleport to a spawnpoint (argument: optional)
        set       : set a spawnpoint (argument: optional)
        remove    : remove a spawnpoint (argument: required)
        clear     : clear all spawnpoints (argument: ignored)
        list      : list all spawnpoints (argument: ignored)
        tidy      : remove duplicate and empty lines (argument: ignored)
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
        elif ! [[ $2 =~ $is_number ]]; then
            target=$2
        else
            echo "Error: $2 is not a number"
            exit 1
        fi
        # check target is le than number of lines
        if [ $target -gt $(wc -l $SPAWNPOINTS_FILE | cut -d' ' -f1) ]; then
            echo "Error: $target is greater than number of lines"
            exit 1
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
    tidy)
        # check file has no empty lines
        beforelinenum=$(wc -l $SPAWNPOINTS_FILE | cut -d' ' -f1)
        sed -i '/^\s*$/d' $SPAWNPOINTS_FILE
        afterlinenum=$(wc -l $SPAWNPOINTS_FILE | cut -d' ' -f1)
        [ $beforelinenum -eq $afterlinenum ] && echo "No empty lines" || echo "Removed $((beforelinenum - afterlinenum)) empty lines"
        # check file has no duplicate lines
        uniq -u $SPAWNPOINTS_FILE > $SPAWNPOINTS_FILE.tmp
        beforelinenum=$(wc -l $SPAWNPOINTS_FILE | cut -d' ' -f1)
        afterlinenum=$(wc -l $SPAWNPOINTS_FILE.tmp | cut -d' ' -f1)
        [ $beforelinenum -eq $afterlinenum ] && echo "No duplicate lines" || echo "Removed $((beforelinenum - afterlinenum)) duplicate lines"
        mv $SPAWNPOINTS_FILE.tmp $SPAWNPOINTS_FILE
        ;;
    *help | -h)
        Usage
        exit 0
        ;;
    --version)
        echo "SpawnPoints Magic for Linux $__version__"
        exit 0
        ;;
    -v)
        echo $__version__
        exit 0
        ;;
    *)
        echo "Invalid option!"
        Usage
        exit 1
        ;;
esac
