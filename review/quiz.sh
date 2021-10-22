#!/bin/bash

correct=0
questions=0


if [[ -x system_design.sh ]]; then
    ./system_design.sh
else
    chmod +x system_design.sh
    ./system_design.sh
fi


# cat phone-numbers.txt | grep -P "[^\s.](?:[^?.]|\.(?! ))*\?"
# if [[ CAPITAL -eq  'Austin' ]]; then
#     ((correct=correct+1))
# else
#     echo "Wrong! The correct answer is Austin"
# fi

# ((questions=questions+1))

# score=$(((questions / correct) * 100 ))
# echo $score

# echo -n "The official language of $COUNTRY is "

# case $COUNTRY in

#   Lithuania)
#     echo -n "Lithuanian"
#     ;;

#   Romania | Moldova)
#     echo -n "Romanian"
#     ;;

#   Italy | "San Marino" | Switzerland | "Vatican City")
#     echo -n "Italian"
#     ;;

#   *)
#     echo -n "unknown"
#     ;;
# esac
