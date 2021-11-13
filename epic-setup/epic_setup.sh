#!/bin/bash

make_script_executable() {
    if [ ! -x "$1" ]; then
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
    if [ -x "$FILE_PATH"/backend.sh ]; then
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
    echo "   Syntax: epic-setup [-n|d|s]"
    echo "   options:"
    echo "   n     Name the application."
    echo "   d     Configure the database. [mongo|redis|postgres]"
    echo "   s     Configure the service name. [customer|user]"
    echo
}

while getopts n:d:s: flag; do
    case "${flag}" in
    n) APP_NAME=${OPTARG} ;;
    d) DATABASE=${OPTARG} ;;
    s) SERVICE_NAME=${OPTARG} ;;
    *) help 
       exit 1 ;;
    esac
done

if [[ ! -z "$APP_NAME" && ! -z "$DATABASE" && ! -z "$SERVICE_NAME" ]]; then
    symlink=$(read_symbolic_link $(which epic-setup))
    make_script_executable "${symlink}/db/${DATABASE}.sh"
    "${symlink}/db/${DATABASE}.sh" "${APP_NAME}" "$SERVICE_NAME"
else
    read_from_terminal
fi

