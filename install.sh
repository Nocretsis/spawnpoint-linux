# User defined variables
PATH_FOLDER_LINK=~/.local/bin
SPAWNPOINTS_FILE=~/.spawnpoints
SHELLRC=~/.bashrc
FLAG="--set-alias"
# end of user defined variables


_step=0
echo "[$_step] Checking if file exists..."

# Check if file exists
echo "[$((++_step))] loading spawnpoints-magic dependencies..."
loc_parent=$(dirname $(readlink -f $0))
count=0
for file in $(ls $loc_parent/spawnpoints-magic-*); do
    
    echo -en "\r[$_step] loading file... $count/3"
    found=$([ -f $file ] && echo 1 || echo 0)
    if [ $found -eq 0 ]; then
        echo -e "\n[✕] Error: missing dependencies: $file"
        exit 1
    fi
    count=$((count+found))
done
echo -en "\r[$_step] loading file... $count/3 DONE\n"
echo $((++_step)) > /dev/null

if [ ! -f "$SPAWNPOINTS_FILE" ]; then
    echo "[…] initiating spawnpoint file..."
    touch $SPAWNPOINTS_FILE
    echo $HOME > $SPAWNPOINTS_FILE
fi

# Check if FOLDER_LINK exists
if [ ! -d "$PATH_FOLDER_LINK" ]; then
    echo "[✕] Missing folder: $PATH_FOLDER_LINK"
    exit 1
fi

# Check if file exists
if [ -f "$PATH_FOLDER_LINK/spawnpoints-manager" ] ; then
    echo "[$_step] Removing old symlink..."
    rm "$PATH_FOLDER_LINK/spawnpoints-manager"
fi
ln -s $loc_parent/spawnpoints-magic-manager.sh "$PATH_FOLDER_LINK/spawnpoints-manager"
echo "[$_step] Linking manager to $PATH_FOLDER_LINK/spawnpoints-manager"
echo $((++_step)) > /dev/null
# source $loc_parent/spawnpoints-magic-source to SHELLRC
if ! grep -q "spawnpoints-magic-source" $SHELLRC; then
    echo "source $loc_parent/spawnpoints-magic-source" >> $SHELLRC
    echo "[$_step] Added source $loc_parent/spawnpoints-magic-source to $SHELLRC"
else
    echo "[$_step] source <spawnpoints> already exists in $SHELLRC"
    # re-inject source
    sed -i '/spawnpoints-magic-source/d' $SHELLRC
    echo "source $loc_parent/spawnpoints-magic-source" >> $SHELLRC
    echo "[$_step] Re-injected source <spawnpoints> to $SHELLRC"
fi
echo $((++_step)) > /dev/null
# read flag:
# --set-alias: set alias for spawnpoints to sp
# --no-alias: unset alias for spawnpoints

#covering flag
IFS=' ' read -r -a FLAG <<< "$FLAG"
FLAG=("${FLAG[@]}" "$@")
for flag in "${FLAG[@]}"; do
    echo -n "[$_step] Checking flag: '$flag'"
    case $flag in
        "--set-alias")
            if $(grep -q "source $loc_parent/spawnpoints-magic-alias" $SHELLRC); then
                echo ">>> alias already exists in $SHELLRC"
            else
                echo "source $loc_parent/spawnpoints-magic-alias" >> $SHELLRC
                echo ">>> alias added to $SHELLRC"
            fi 
            shift
            ;;
        "--no-alias")
            if $(grep -q "source $loc_parent/spawnpoints-magic-alias" $SHELLRC); then
                sed -i '/spawnpoints-magic-alias/d' $SHELLRC
                echo ">>> alias removed from $SHELLRC"
            else
                echo ">>> alias does not exist in $SHELLRC"
            fi
            shift
            ;;
        '' )
            break
            ;;
        * )
            echo ">>> Unknown"
            ;;
    esac
done 

echo "[✓] Done!"

echo "To use spawnpoints, open a new terminal or run 'source $SHELLRC'"