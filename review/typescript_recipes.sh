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


read -p "Sort the list in descending order.

        let artists = [
            'John White Abbott',
            'Leonardo da Vinci',
            'Charles Aubry',
            'Anna Atkins',
            'Barent Avercamp'
        ];

        artists.sort(function (a, b) {
           return a === b ? 0 : a > b ? -1 : 1;
        });

Enter your answer: " response
answer="a === b ? 0 : a > b ? -1 : 1;"
evaluate_answer "$response" "$answer"
additional_feedback="
    let artists = [
        'John White Abbott',
        'Leonardo da Vinci',
        'Charles Aubry',
        'Anna Atkins',
        'Barent Avercamp'
    ];

    artists.sort(function (a, b) {
        return a === b ? 0 : a > b ? -1 : 1;
    });
"



next_question




read -p "What would the output of the following code?

    let ages = [2, 1000, 10, 3, 23, 12, 30, 21];

    ages.sort();
    console.log(ages);

Enter your answer: " response
answer="10, 1000, 12, 2, 21, 23, 3, 30"
evaluate_answer "$response" "$answer"



next_question



read -p "In the previous answer, why did the program output those results?" response
answer="Because with the default sort(), elements are converted to strings and compared in UTF-16 code units order."
evaluate_answer "$response" "$answer"



next_question


read -p "How would you properly sort the previous example in ascending order? 

    ages.sort(function (a, b) {
       return b - a;
    });


Enter your answer: " response
answer="a - b"
additional_feedback="

    Correct.
    
    ages.sort(function (a, b) {
       return a - b;
    });

"


