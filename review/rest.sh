#!/bin/bash

correct=0
questions=0

increment_correct_responses() {
    ((correct = correct + 1))
}

increment_questions_count() {
    ((questions = questions + 1))
}

affirm_answer() {
    if [[ -z "$1" ]]; then
        echo "
    Correct. 

    "
    else
        echo "$1"
    fi
}

evaluate_answer() {

    if [[ "$1" == "$2" ]]; then
        increment_correct_responses
        affirm_answer "$3"
    else

        echo "
    
    Wrong! There is no tommorrow, so get this right right now!
    
    "
    fi
}

next_question() {
    echo "
 ########################################
             Next Question 
 ########################################
"
}

read -p "Complete this sentence: 
    An HTTP method is __________ if an identical request can be made __________
    in a row with the same effect while leaving the server in the same state. 
    In other words, an idempotent method should not have any side-effects (except for 
    keeping statistics).
    
Enter your answer: " response

answer="idempotent once or several times"
additional_feedback="
    Correct.

    An HTTP method is idempotent if an identical request can be made once or several 
    times in a row with the same effect while leaving the server in the same state. 
    In other words, an idempotent method should not have any side-effects (except for 
    keeping statistics).
"
evaluate_answer "$response" "$answer" "$additional_feedback"



next_question



read -p "Complete this sentence: 

         Implemented correctly, the ____, ______, _____, and _____ methods are 
         idempotent, but not the ______ method. All _____ methods are also idempotent.

Enter your answer: " response
additional_feedback="Implemented correctly, the GET, HEAD, PUT, and DELETE methods are 
                     idempotent, but not the POST method. All safe methods are also idempotent."
answer="GET HEAD PUT DELETE POST safe"
evaluate_answer "$response" "$answer" "$additional_feedback"



next_question



read -p "Complete this sentence: 
         
         POST is idempotent because if called several times, it ____________.

Enter your answer: " response
answer="adds several rows"
additional_feedback="
    Correct.

    POST is idempotent because if called several times, it adds several rows.

    
"
evaluate_answer "$response" "$answer" "$additional_feedback"



next_question



read -p "Complete this sentence: 
        
        The HTTP GET method ________ a representation of the specified resource.

Enter your answer: " response
answer="request"
additional_feedback="
     Correct.

     The HTTP GET method request a representation of the specified resource.

"
evaluate_answer "$response" "$answer" "$additional_feedback"



next_question




read -p "Complete this sentence: 
         The HTTP PATCH request method applies _____ _______ to a resource.       

Enter this answer: " response
answer="partial modifications"
additional_feedback="
    Correct.
    The HTTP PATCH request method applies partial modifications to a resource.
"
evaluate_answer "$response" "$answer" "$additional_feedback"




next_question



read -p "Complete this sentence: 

        The HTTP PUT request method ______ a new resource or _____ 
        a representation of the target resource with the ______ _______.

Enter your answer: " response
answer="creates replaces request payload"
additional_feedback="
    Correct.
    The HTTP PUT request method creates a new resource or replaces 
    a representation of the target resource with the request payload.
"
evaluate_answer "$response" "$answer" "$additional_feedback"



next_question




read -p "Complete this sentence:

         When the PUT request successfully creates a representation, then the 
         origin server must inform the user agent by sending a ___ ______ 
         _______.

Enter your answer: " response
additional_feedback="
        Correct.

        When the PUT request successfully creates a representation, then the 
        origin server must inform the user agent by sending a 201 (Created) 
        response.
"
evaluate_answer "$response" "$answer" "$additional_feedback"




next_question



read -p "What is the difference between PUT and POST? " response
answer="PATCH is a set of instructions on how to modify a resource. PUT is a complet respentation of a resource."
additional_feedback="
        Correct.

        A PATCH request is considered a set of instructions on how to modify a resource. 
        Contrast this with PUT; which is a complete representation of a resource.
"
evaluate_answer "$response" "$answer" "$additional_feedback"



next_question




read -p "Complete this sentence: 
    
         The HTTP POST method _________________. 

Enter your answer: " response
answer="sends data to the server"
additional_feedback="
        Correct.

        The HTTP POST method sends data to the server.
"
evaluate_answer "$response" "$answer" "$additional_feedback"



next_question



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
    echo "    You scored $score% on REST knowledge."
fi

