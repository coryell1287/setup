#!/bin/bash

GREEN='\033[0;37m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
RESET='\033[0m'
hour="${hour:-0}"
min="${min:-30}"
sec="${sec:-00}"
tput civis
echo -ne "${GREEN}"
while [ $hour -ge 0 ]; do
    while [ $min -ge 0 ]; do
        while [ $sec -ge 0 ]; do
            if [ "$hour" -eq "0" ] && [ "$min" -eq "0" ]; then
                echo -ne "${YELLOW}"
            fi
            if [ "$hour" -eq "0" ] && [ "$min" -eq "0" ] && [ "$sec" -le "10" ]; then
                echo -ne "${RED}"
            fi
            echo -ne "$(printf "%02d" $hour):$(printf "%02d" $min):$(printf "%02d" $sec)\033[0K\r"
            let "sec=sec-1"
            sleep 1
        done
        sec=59
        let "min=min-1"
    done
    min=59
    let "hour=hour-1"
done
echo -e "${RESET}"
tput cnorm
