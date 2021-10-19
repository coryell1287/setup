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
