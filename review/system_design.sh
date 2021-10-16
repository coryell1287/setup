#!/bin/bash

correct=0
questions=0

increment_correct_responses() {
    ((correct = correct + 1))
}

increment_questions_count() {
    ((questions = questions + 1))
}

echo "
   ########################################
              System Requirements
   ########################################
"
read -p "Complete this sentence:

      Solution Requirement defines a ____ the solution will
      perform, ____ it will manipulate, a ____ it possses, 
      OR a ___ it must meet. 

Enter your answer: " response

answer="function data quality constraint"

if [[ "$response" == "$answer" ]]; then
    increment_correct_responses

    echo "
    Correct. 

    Solution Requirement defines a function the solution will 
    perform, data it will manipulate, a quality it possses, 
    OR a constraint it must meet. 
    "
else
    echo "
    
    Wrong! There is no pass. Only fail.
    
    "
fi

increment_questions_count

echo "
 ########################################
             Next Question 
 ########################################
"

read -p "What information do you need know first to determine traffic estimates? " response
answer="read/write ratio"

if [[ "$response" == "$answer" ]]; then
    increment_correct_responses

    echo "
    Correct. 

    Once you know the read/write ratio, then multiple the estimates for the number of reads
    by the number of writes. Example: 500M new tiny urls are created every month. 
    The read/write ratio is 100:1. Multiplying 500M by 100 comes to 50 billion requests every month.

    "
else
    echo "
    
    Wrong! There is no pass. Only fail.
    
    "
fi

increment_questions_count


echo "
 ########################################
             Next Question 
 ########################################
"

read -p "How do you calcuate the queries per second? " response
answer="Calcuate how many writes are process per second. Then multiple that by then read in read/write ratio."

if [[ "$response" == "$answer" ]]; then
    increment_correct_responses

    echo "
    Correct. 
    "
else
    echo "
    
    Wrong! There is no pass. Only fail.
    
    "
fi

increment_questions_count

echo "
 ########################################
             Next Question 
 ########################################
"

read -p "What's the formula for calculating queries per second? " response
answer="30 days * 24 hours * 3600 seconds"

if [[ "$response" == "$answer" ]]; then
    increment_correct_responses

    echo "
    Correct. 

    500 million new URLs created every month is ~200 URLs create per second

    500 million / (30 days * 24 hours * 3600 seconds) = ~200 URLs/s

    Now multiple that by the read in the read/write ratio.
    
    100 * 200 URLs/s = 20K/s
    "
else
    echo "
    
    Wrong! There is no pass. Only fail.
    
    "
fi

increment_questions_count

########################################
#         Calculate your score         #
########################################

((questions = questions + 1))

if [[ correct -eq 0 ]]; then
    echo "
    You got nothing correct. Stop and go study.
    
    "
else
    score=$(((questions / correct) * 100))
    echo "    You scored $score% on system design."
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
