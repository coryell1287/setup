#!/bin/bash


read -p "Enter application name: " APP_NAME
read -p "Enter github url: " GITHUB_URL
echo APP_NAME
echo GITHUB_URL
NODE=$(node -v)
NODE_VERSION="${NODE#?}" 
# Ask whether frontend, backend or both
# if both, ask whether mono repo, separate repo, no report

if [[ -x ./backend.sh ]]; then
    ./backend.sh
else
    chmod -x ./backend.sh
    ./backend.sh
fi
