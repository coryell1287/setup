#!/bin/bash

make_script_executable() {
    if [[ ! -x "$1" ]]; then
        chmod 755 "$1"
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
    printf "${EPIC_DIR%/*}"
}

execute_setup() {
    FILE_PATH=$1
    APP_NAME=$2
    NODE_VERSION=$3
    GITHUB_URL=$4
    if [[ -x "$FILE_PATH"/backend.sh ]]; then
        "$FILE_PATH"/backend.sh "$APP_NAME" "$NODE_VERSION"
    else
        chmod -x "$FILE_PATH"/backend.sh
        "$FILE_PATH"/backend.sh "$APP_NAME" "$NODE_VERSION" "$GITHUB_URL"
    fi

}

read_from_terminal() {
    read -p "Enter application name: " APP_NAME
    read -p "Enter github url: " GITHUB_URL
    NODE=$(node -v)
    NODE_VERSION="${NODE#?}"
    symlink=$(read_symbolic_link $(which epic-setup))
    execute_setup "$symlink" "$APP_NAME" "$NODE_VERSION" "$GITHUB_URL"
}

help() {
    echo "
   Execute script to add a database to the current project.
   "
    echo "   Syntax: epic-setup [-n|d|]"
    echo "   options:"
    echo "   n     Name the application."
    echo "   d     Configure the database. [mongo|redis|postgres]"
    echo
}

while getopts n:d: flag; do
    case "${flag}" in
    n) APP_NAME=${OPTARG} ;;
    d) DATABASE=${OPTARG} ;;
    *) help exit 1 ;;
    esac
done

if [[ ! -z "$APP_NAME" && ! -z "$DATABASE" ]]; then
    symlink=$(read_symbolic_link $(which epic-setup))
    make_script_executable "${symlink}/db/${DATABASE}.sh"
    "${symlink}/db/${DATABASE}.sh" "${APP_NAME}"
else
    read_from_terminal
fi

# echo $APP_NAME
# echo $GITHUB_URL
# # Ask whether frontend, backend or both
# # if both, ask whether mono repo, separate repo, no repo

# read_symbolic_link $(which epic-setup)

# while true; do
#   case "$1" in
#     -n|--name)
#       APP_NAME="$2"
#       shift 2;;
#     -d|--database)
#       DATA_BASE="$2"
#       shift 2;;
#     --)
#       break;;
#      *)
#       printf "Unknown option %s\n" "$1"
#       exit 1;;
#   esac
# done

# echo "$APP_NAME"
# echo "$DATABASE"

# # PS3="Please enter your choice: "
# # options=("Option 1" "Option 2" "Option 3" "Quit")
# # select opt in "${options[@]}"
# # do
# #     case $opt in
# #         "Option 1")
# #             echo "you chose choice 1"
# #             break
# #             ;;
# #         "Option 2")
# #             echo "you chose choice 2"
# #             break
# #             ;;
# #         "Option 3")
# #             echo "you chose choice $REPLY which is $opt"
# #             break
# #             ;;
# #         "Quit")
# #             break
# #             ;;
# #         *) echo "invalid option $REPLY";;
# #     esac
# # done
