#!/bin/bash

read -p "Enter application name: " APP_NAME
read -p "Enter github url: " GITHUB_URL
echo $APP_NAME
echo $GITHUB_URL
NODE=$(node -v)
NODE_VERSION="${NODE#?}"
# Ask whether frontend, backend or both
# if both, ask whether mono repo, separate repo, no repo

execute_setup() {
    if [[ -x "$1"/backend.sh ]]; then
        "$1"/backend.sh "$APP_NAME" "$NODE_VERSION"
    else
        chmod -x "$1"/backend.sh
        "$1"/backend.sh "$APP_NAME" "$NODE_VERSION"
    fi

}

read_symbolic_link() {
    linkfile="$1"
    if [ ! -L "$linkfile" ]; then
        echo "$linkfile is not a simbolik link" >&2
        return 1
    fi
    until [ ! -L "$linkfile" ]; do
        lastlinkfile="$linkfile"
        linkfile=$(readlink "$lastlinkfile")
    done
    EPIC_DIR=$(readlink "$lastlinkfile")
    execute_setup ${EPIC_DIR%/*}
}

read_symbolic_link $(which epic-setup)

# http://www.freekb.net/Article?id=1140
# example.sh -f client -b server
# ARGS=$(getopt -a --options f:b: --long "frontend:,backend:" -- "$@")
# eval set -- "$ARGS"

# while true; do
#   case "$1" in
#     -n|--name)
#       name="$2"
#       shift 2;;
#     -o|--occupation)
#       occupation="$2"
#       shift 2;;
#     --)
#       break;;
#      *)
#       printf "Unknown option %s\n" "$1"
#       exit 1;;
#   esac
# done

# PS3="Please enter your choice: "
# options=("Option 1" "Option 2" "Option 3" "Quit")
# select opt in "${options[@]}"
# do
#     case $opt in
#         "Option 1")
#             echo "you chose choice 1"
#             break
#             ;;
#         "Option 2")
#             echo "you chose choice 2"
#             break
#             ;;
#         "Option 3")
#             echo "you chose choice $REPLY which is $opt"
#             break
#             ;;
#         "Quit")
#             break
#             ;;
#         *) echo "invalid option $REPLY";;
#     esac
# done
