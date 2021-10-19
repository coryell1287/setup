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

    (Providers need sense of direction in all four dimensions 
    for each requirement to guide their decision-making process.)
    "
else
    echo "
    
    Wrong! There is no tommorrow, so get this right right now!
    
    "
fi

increment_questions_count

echo "
 ########################################
             Next Question 
 ########################################
"

read -p "How should you name functional requirements?  Your answer: " response

answer="You should name functional requirements using the verb object form."

if [[ "$response" == "$answer" ]]; then
    increment_correct_responses

    echo "
    Correct. 

    * use an active verb (one that states the action)
    * and direct objects (the things the action creates or affects)
    (e.g., \"Calculate sales tax\", \"Verify Order\")
    "
else
    echo "
    
    Wrong! There is no tommorrow, so get this right right now!
    
    "
fi

increment_questions_count

echo "
 ########################################
             Next Question 
 ########################################
"

read -p "
    Read the following requirement and state the explicit functionality.

    \"The application should calcuate the premium for safe drivers.\"


Enter your answer: " response

answer="The requirement states that the application needs to know the premium to calcuate premium discount."

if [[ "$response" == "$answer" ]]; then
    increment_correct_responses

    echo "
    Correct. 

    "
else
    echo "
    
    Wrong! There is no tommorrow, so get this right right now!
    
    "
fi

increment_questions_count

echo "
 ########################################
             Next Question 
 ########################################
"

read -p "
    Read the following requirement and state the IMPLICIT functionality.

    \"The application should calcuate the premium for safe drivers.\"


Enter your answer: " response

answer="The requirement implies that the application needs a function to evaluate driving record to determine a safe driver."

if [[ "$response" == "$answer" ]]; then
    increment_correct_responses

    echo "
    Correct. 

    Look for qualifiers in the requirements. In the example 
    where the person is referred to as a safe driver, there has 
    to be some details stored on the driver to evaluate whether the 
    driver is safe. Revealing this specific uncovers hidden functionality.
    "
else
    echo "
    
    Wrong! There is no tommorrow, so get this right right now!
    
    "
fi

increment_questions_count


echo "
 ########################################
             Next Question 
 ########################################
"

read -p "
    Complete the following statement.   

     Requirement decomposition or requirement drill-down generates...?


Enter your answer: " response

answer="functional requirements Informational requirements qualities and constraints"

if [[ "$response" == "$answer" ]]; then
    increment_correct_responses

    echo "
    Correct. 

    Requirement decomposition or requirement drill-down generates functional,
    informational, qualities and constraint requirements.
    "
else
    echo "
    
    Wrong! There is no tommorrow, so get this right right now!
    
    "
fi

increment_questions_count


echo "
 ########################################
             Next Question 
 ########################################
"

read -p "What are informational Components? " response

answer="user views or data elements"

if [[ "$response" == "$answer" ]]; then
    increment_correct_responses

    echo "
    Correct. 

    "
else
    echo "
    
    Wrong! There is no tommorrow, so get this right right now!
    
    "
fi

increment_questions_count


echo "
 ########################################
             Next Question 
 ########################################
"

read -p "What is a user view? " response

answer="a collection of data elements"

if [[ "$response" == "$answer" ]]; then
    increment_correct_responses

    echo "
    Correct. 

    A user view would be a Customer Address.
    "
else
    echo "
    
    Wrong! There is no tommorrow, so get this right right now!
    
    "
fi

increment_questions_count

echo "
 ########################################
             Next Question 
 ########################################
"

read -p "What are data elements?  " response

answer="Are the attributes of the user view."

if [[ "$response" == "$answer" ]]; then
    increment_correct_responses

    echo "
    Correct. 

    Data elements for a Customer Address are customer name, street address and zipcode.
    "
else
    echo "
    
    Wrong! There is no tommorrow, so get this right right now!
    
    "
fi

increment_questions_count


echo "
   ########################################
      Capacity Estimation and Constraints
   ########################################
"


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
    
    Wrong! There is no tommorrow, so get this right right now!
    
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
    
    Wrong! There is no tommorrow, so get this right right now!
    
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
    
    Wrong! There is no tommorrow, so get this right right now!
    
    "
fi

increment_questions_count



echo "
 ########################################
             Next Question 
 ########################################
"

read -p "What would the ideal steps be in designing software? " response
answer="iniation analysis design development testing delivery"

if [[ "$response" == "$answer" ]]; then
    increment_correct_responses

    echo "
    Correct. 


        1). Iniation 
        2). Analysis 
        3). Design 
        4). Development 
        5). Testing 
        6). Delivery
    "
else
    echo "
    
    Wrong! There is no tommorrow, so get this right right now!
    
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



echo "
        __________________________________________________
        |                   TOPIC               | SCORE  |
        |---------------------------------------|----------
        |   Requirements and Goals Gathering    | 
        |---------------------------------------|
        |   Capacity Estimations and Constraints |
        |   System APIs
        |   Database Design 
        |   Basic System Design and Algorithm
        |   Data Partitioning and Replication
        |   Caching
        |   Loading Balancer
        |   Purging or DB cleanup

"