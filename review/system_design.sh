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

    increment_questions_count
}

next_question() {
    echo "
 ########################################
             Next Question 
 ########################################
"
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
additional_feedback="
    Correct. 

    Solution Requirement defines a function the solution will 
    perform, data it will manipulate, a quality it possses, 
    OR a constraint it must meet. 

    (Providers need sense of direction in all four dimensions 
    for each requirement to guide their decision-making process.)
    "
evaluate_answer "$response" "$answer" "$additional_feedback"



next_question


read -p "How should you name functional requirements?  Your answer: " response
answer="You should name functional requirements using the verb object form."
additional_feedback="
    Correct. 

    * use an active verb (one that states the action)
    * and direct objects (the things the action creates or affects)
    (e.g., \"Calculate sales tax\", \"Verify Order\")
    "
evaluate_answer "$response" "$answer" "$additional_feedback"



next_question


read -p "
    Read the following requirement and state the explicit functionality.

    \"The application should calcuate the premium for safe drivers.\"


Enter your answer: " response
answer="The requirement states that the application needs to know the premium to calcuate premium discount."
evaluate_answer "$response" "$answer"



next_question



read -p "
    Read the following requirement and state the IMPLICIT functionality.

    \"The application should calcuate the premium for safe drivers.\"


Enter your answer: " response

answer="The requirement implies that the application needs a function to evaluate driving record to determine a safe driver."
additional_feedback="
    Correct. 

    Look for qualifiers in the requirements. In the example 
    where the person is referred to as a safe driver, there has 
    to be some details stored on the driver to evaluate whether the 
    driver is safe. Revealing this specific uncovers hidden functionality.
    "
evaluate_answer "$response" "$answer" "$additional_feedback"


next_question


read -p "
    Complete the following statement.   

     Requirement decomposition or requirement drill-down generates...?


Enter your answer: " response

answer="functional requirements Informational requirements qualities and constraints"
additional_feedback="
    Correct. 

    Requirement decomposition or requirement drill-down generates functional,
    informational, qualities and constraint requirements.
    "
evaluate_answer "$response" "$answer" "$additional_feedback"



next_question


read -p "What are informational Components? " response

answer="user views or data elements"
evaluate_answer "$response" "$answer"



next_question



read -p "What is a user view? " response
answer="a collection of data elements"
additional_feedback="
    Correct. 

    A user view would be a Customer Address.

"
evaluate_answer "$response" "$answer" "$additional_feedback"



next_question



read -p "What are data elements? " response
answer="Are the attributes of the user view."
additional_feedback="
    Correct. 

    Data elements for a Customer Address are customer name, street address and zipcode.

"
evaluate_answer "$response" "$answer" "$additional_feedback"


next_question


read -p "What would the ideal steps be in designing software? " response
answer="iniation analysis design development testing delivery"
additional_feedback="
    Correct. 


        1). Iniation 
        2). Analysis 
        3). Design 
        4). Development 
        5). Testing 
        6). Delivery
"
evaluate_answer "$response" "$answer" "$additional_feedback"

echo "
   ########################################
      Capacity Estimation and Constraints
   ########################################
"

next_question


read -p "What information do you need know first to determine traffic estimates? " response
answer="read/write ratio"
additional_feedback="
    Correct. 

    Once you know the read/write ratio, then multiple the estimates for the number of reads
    by the number of writes. Example: 500M new tiny urls are created every month. 
    The read/write ratio is 100:1. Multiplying 500M by 100 comes to 50 billion requests every month.

"
evaluate_answer "$response" "$answer" "$additional_feedback"



next_question



read -p "How do you calcuate the queries per second? " response
answer="Calcuate how many writes are process per second. Then multiple that by then read in read/write ratio."
evaluate_answer "$response" "$answer"



next_question



read -p "What's the formula for calculating queries per second? " response
answer="30 days * 24 hours * 3600 seconds"
additional_feedback="
    Correct. 

    500 million new URLs created every month is ~200 URLs create per second

    500 million / (30 days * 24 hours * 3600 seconds) = ~200 URLs/s

    Now multiple that by the read in the read/write ratio.
    
    100 * 200 URLs/s = 20K/s

"
evaluate_answer "$response" "$answer" "$additional_feedback"



next_question



read -p "How would you calcuate the total capacity required for a storage system? " response
answer="Estimate the total number of objects you expect to store, which is the number of objects created every month, and multiple that by the number years you plan to store them. Then multiple that by the number of estimated bytes each object will be."
additional_feedback="
        Correct.

        Storage estimates: Let’s assume we store every URL shortening request (and associated 
        shortened link) for 5 years. Since we expect to have 500M new URLs every month, the 
        total number of objects we expect to store will be 30 billion:

        500 million * 5 years * 12 months = 30 billion
        Let’s assume that each stored object will be approximately 500 bytes (just a ballpark 
        estimate–we will dig into it later). We will need 15TB of total storage:

        30 billion * 500 bytes = 15 TB
"
evaluate_answer "$response" "$answer" "$additional_feedback"


next_question



read -p "How would you approach estimating bandwith? " response
answer="Multiple the number of writes per second by the number of bytes per object. Then multiple the number of reads per second by number of bytes per object."
additional_feedback="

        Bandwidth estimates: For write requests, since we expect 200 new URLs every 
        second, total incoming data for our service will be 100KB per second:

        200 * 500 bytes = 100 KB/s

        For read requests, since every second we expect ~20K URLs redirections, total 
        outgoing data for our service would be 10MB per second:

        20K * 500 bytes = ~10 MB/s

"
evaluate_answer "$response" "$answer" "$additional_feedback"



next_question


read -p "How you would you approach estimating memory storage for caching? " response
answer="Follow the 80-20 principle and assume that 80 percent of the traffic will be generated by 20 percent of the users. Now multiple the number of reads per second by the seconds in a day multiplied by hours in a day. Then multiple the 20 percent by the total number of reads per day multiplied by the number bytes per object."
additional_feedback="

        Correct.

        Memory estimates: If we want to cache some of the hot URLs that are 
        frequently accessed, how much memory will we need to store them? If we 
        follow the 80-20 rule, meaning 20% of URLs generate 80% of traffic, we 
        would like to cache these 20% hot URLs.

        Since we have 20K requests per second, we will be getting 1.7 billion 
        requests per day:

        20K * 3600 seconds * 24 hours = ~1.7 billion

        To cache 20% of these requests, we will need 170GB of memory.

        0.2 * 1.7 billion * 500 bytes = ~170GB

        One thing to note here is that since there will be many duplicate requests 
        (of the same URL), our actual memory usage will be less than 170GB.

"
evaluate_answer "$response" "$answer" "$additional_feedback"


echo "
    ########################################
    #           System APIs                #
    ########################################  

"
read -p "How might the API for a short link look? " response
answer="createURL(api_dev_key: string, original_url?: string, custom_alias?: string, user_name?: string, expire_date?: date): string"
evaluate_answer "$response" "$answer"



next_question



read -p "Explain the purpose of each parameter for the short link API: " response
answer="api_dev_key is used to authenticate a project with the API. original_url to be shortened. custom_alias for the user to create an alias. user_name to be used in the encoding. expire_date to expire the shortened URL. And it returns a string."
evaluate_answer "$response" "$answer"



next_question



read -p "How might the delete API for the short link look? " response
answer="deleteURL(api_dev_key: string, url_key: string): void"
evaluate_answer "$response" "$answer"



next_question



read -p "How do we detect and prevent abuse? " response
answer="To prevent abuse, we can limit users via their api_dev_key."
additional_feedback="

        How do we detect and prevent abuse? A malicious user can put us 
        out of business by consuming all URL keys in the current design. 
        To prevent abuse, we can limit users via their api_dev_key. Each 
        api_dev_key can be limited to a certain number of URL creations 
        and redirections per some time period (which may be set to a different 
        duration per developer key).
"
evaluate_answer "$response" "$answer" "$additional_feedback"



read -p "How might the API for a PasteBin look? " response
answer="addPaste(api_dev_key: string, paste_data: string, custom_url?: string, user_name?: string, paste_name?: string, expire_date?: Date): string"
evaluate_answer "$response" "$answer"


next_question




read -p "Explain the purpose of each parameter for the PasteBin creation API: " response
answer="api_dev_key is used to authenticate a project with the API. paste_data is the textual data of the paste. custom_url is the custom URL. user_name is the user name to be used to generate URL. paste_name is the name of the paste. expire_date is the expiration date for the paste."
evaluate_answer "$response" "$answer"




next_question



read -p "How might the API to retrive a paste look? " response
answer="getPaste(api_dev_key: string, api_paste_key: string): Paste"
evaluate_answer "$response" "$answer"



next_question



read -p "How might the API to delete a paste look? " response
answer="deletePaste(api_dev_key: string, api_paste_key: string): boolean"
evaluate_answer "$response" "$answer"




next_question


echo "
    ########################################
    #           Database Schema            #
    ########################################
    
"

read -p "What kind of database would you use for a short link application? " response
answer="NoSQL"
evaluate_answer "$response" "$answer"



next_question



read -p "How many tables would be needed for a short link application? " response
answer="Two. URL table and a User table."
evaluate_answer "$response" "$answer"


next_question


read -p "Design the table for the short link application. " response
answer="URL table columns would be hash, original_url, creation_date, expiration_date, and user_id. The User table would be user_id, name, email, creation_date, and last_login"
additional_feedback="

        Correct.
        ______________________      ____________________
        |       URL         |       |      User        |
        |-------------------|       |------------------| 
        |   hash            |       |  user_id         | 
        |-------------------|       |------------------|
        |   original_url    |       |  name            |
        |-------------------|       |------------------|
        |   creation_date   |       |  email           |   
        |-------------------|       |------------------|
        |   expiration_date |       |  creation_date   |        
        |-------------------|       |------------------|
        |   user_id         |       |  last_login      | 
        |-------------------|       |------------------| 
        

"
evaluate_answer "$response" "$answer" "$additional_feedback"




next_question


read -p "Design the table for the PasteBin application. " response
answer="Paste table columns would be hash, original_url, creation_date, expiration_date, and user_id. The User table would be user_id, name, email, creation_date, and last_login"
additional_feedback="

        Correct.
        ______________________      ____________________
        |       Paste       |       |      User        |
        |-------------------|       |------------------| 
        |   url_hash        |       |  user_id         | 
        |-------------------|       |------------------|
        |   content_key     |       |  name            |
        |-------------------|       |------------------|
        |   creation_date   |       |  email           |   
        |-------------------|       |------------------|
        |   expiration_date |       |  creation_date   |        
        |-------------------|       |------------------|
        |   user_id         |       |  last_login      | 
        |-------------------|       |------------------| 
        

"
evaluate_answer "$response" "$answer" "$additional_feedback"



next_question


read -p "What is one big reason scaling a SQL database is difficult? " response
answer="They have to be Sharded or Replicated to make them run smoothly on a cluster."
evaluate_answer "$response" "$answer"


next_question



read -p "Why are NoSQL databases easier to scale? " response
answer="NoSQL databases have the ability to add new server nodes on without any human intervention."
evaluate_answer "$response" "$answer"



next_question


read -p "What do the abbreviations in CAP theorem mean? " response
answer="Consistency (C) means that all components of the system have the same information. Availability (A) means that no system stops working because another system failed. Partition tolerance (P) means that a system will continue to work in case of arbitrary package loss in the network."
evaluate_answer "$response" "$answer"


next_question


read -p "What is the a basic principle of CAP theorem? " response
answer="The CAP theorem states that a system can have a maximum of two features out of these three: Availability and Partition tolerance."
evaluate_answer "$response" "$answer"



next_question


read -p "What is  special about Partition tolerance? " response
answer="A system must react if the network fails. Complete failure is not necessary; the package loss just needs to be high or the response time is very long. A system that responds very slowly is indistinguishable from a system that has failed completely."
evaluate_answer "$response" "$answer"



next_question




read -p "What are two options as to how a system can react to a request when the network? " response
answer="In the AP case, the system provides a response. The response can be wrong because changes have not reached the system. The system might return a different response from systems that have obtained newer information, creating inconsistency. In the CP case, the system returns no response and is not available when there is a problem. Or, all systems always return the same responses and therefore are consistent as long as there is no network partitioning."
additional_feedback="

        Corrcect.

        In the AP case, the system provides a response. The response can be wrong because 
        changes have not reached the system. The system might return a different response 
        from systems that have obtained newer information, creating inconsistency. 

        In the CP case, the system returns no response and is not available when there is 
        a problem. Or, all systems always return the same responses and therefore are consistent 
        as long as there is no network partitioning.
"
evaluate_answer "$response" "$answer" "$additional_feedback"



next_question



read -p "What does ACID stand for? " response
answer="Atomic: It all succeeds or it all fails. Consistent: No partial transactions. Isolated: Transactions don’t overlap. Durable: Once it’s done, it’s done."
additional_feedback="

        Correct.

        Atomic: It all succeeds or it all fails
        Consistent: No partial transactions
        Isolated: Transactions don’t overlap
        Durable: Once it’s done, it’s done

"
evaluate_answer "$response" "$answer" "$additional_feedback"



next_question



read -p "What do relational databases ensure? " response
answer="A relational database ensures that either the system is in State A or State B at all times. If anything fails, the system goes back to State A."
evaluate_answer "$response" "$answer"



########################################
#   Basic System Design and Algorithm  #
########################################




read -p "Which characters are included in base36 encoding? " response
answer="[a-z,0-9]"
evaluate_answer "$response" "$answer"




next_question


read -p "Which characters are included in a base62 encoding? " response
answer="[A-Z,a-z,0-9]"
evaluate_answer "$response" "$answer"




next_question



read -p "Which characters are included in a base64 encoding? " response
answer="[A-Z,a-z,0-9+/]"
evaluate_answer "$response" "$answer"




next_question


read -p "How many possible strings are produced from 6 letters with base64 encoding? " response
answer="~68.7 billion"
additional_feedback="
        
        Correct.

        Using base64 encoding, a 6 letters long key would result in: 
        64^6 = ~68.7 billion possible strings.

"
evaluate_answer "$response" "$answer" "$additional_feedback"



next_question




read -p "How many possible strings are produced from 8 letters with base64 encoding? " response
answer="~281 trillion"
additional_feedback="

        Correct.

        Using base64 encoding, an 8 letters long key would result in:
        64^8 = ~281 trillion possible strings.

"
evaluate_answer "$response" "$answer" "$additional_feedback"




next_question



read -p "A 128-bit hash and 6 letters produces how many characters? " response
answer="21"
additional_feedback="

        Correct.

        128 bits / 6 letters = 21 characters

"
evaluate_answer "$response" "$answer" "$additional_feedback"



next_question



read -p "What is possible solution to prevent duplication from encoding a string? " response
answer="Append an increasing sequence number to each input string to make it unique and then generate its hash."
evaluate_answer "$response" "$answer"




next_question




read -p "What is a potential problem with the previously stated solution? " response
answer="An ever-increasing sequence number could overflow and could impact the performance of the service."
evaluate_answer "$response" "$answer"



next_question




read -p "What is another solution for prevent duplication from encoding a string? " response
answer="Append the user id (which should be unique) to the input URL"
evaluate_answer "$response" "$answer"




next_question



read -p "What is a potential problem with the previously stated solution? " response
answer="If the user has not signed in, we would have to ask the user to choose a uniqueness key. Even after this, if we have a conflict, we have to keep generating a key until we get a unique one."
evaluate_answer "$response" "$answer"



next_question




read -p "How would an offline key-generation service work? " response
answer="Generate random six-letter strings beforehand and store them in a database. Whenever you want to shorten a URL, take one of the already-generated keys and use it."
additional_feedback="

        Correct.

        This approach will make things quite simple and fast. Not only are we not 
        encoding the URL, but we won’t have to worry about duplications or collisions. 
        KGS will make sure all the keys inserted into key-DB are unique.

"
evaluate_answer "$response" "$answer" "$additional_feedback"



next_question



read -p "How would an database for an offline key-generation service work? " response
answer="There would be two tables to store keys: one for keys that are not used yet, and one for all the used keys. As soon as KGS gives keys to one of the servers, it can move them to the used keys table."
evaluate_answer "$response" "$answer"




next_question



read -p "How would you make sure you didn't give the same key to multiple servers? " response
answer="Synchronize (or get a lock on) the data structure holding the keys before removing keys from it and giving them to a server."
evaluate_answer "$response" "$answer"




next_question




read -p "How would you determine the size of the key generation database if each string is six letters and you use base64 encoding? " response
answer="Multiple the characters per key by the number of unique keys base64 can generate."
additional_feedback="

        Correct.
        
        With base64 encoding, we can generate 68.7B unique six letters keys. 
        If we need one byte to store one alpha-numeric character, we can store 
        all these keys in:

        6 (characters per key) * 68.7B (unique keys) = 412 GB.

"
evaluate_answer "$response" "$answer" "$additional_feedback"



next_question



read -p "Isn’t KGS a single point of failure?" response
answer="Yes. To solve this, we can have a standby replica of KGS. Whenever the primary server dies, the standby server can take over to generate and provide keys."
evaluate_answer "$response" "$answer"




next_question




read -p "What the key-generation server crashes? " response
answer="This can be acceptable because base64 encoding 68B unique six-letter keys."
evaluate_answer "$response" "$answer"





next_question





read -p "How would we perform a key lookup in the key-generation service? "
answer="Look up the key in the database to get the full URL. If it’s present in the DB, issue an HTTP 302 Redirect status back to the browser, passing the stored URL in the Location field of the request. If that key is not present in the system, issue an HTTP 404 Not Found status or redirect the user back to the homepage."
evaluate_answer "$response" "$answer"




next_question




read -p "Should there be a size limit on custom aliases for th e key-generation service? " response
answer="It is reasonable to impose a size limit on a custom alias to ensure a consistent URL database. The limit can be set to 16 characters per customer key."
evaluate_answer "$response" "$answer"




echo "

        ########################################
        #  Data Partitioning and Replication   #
        ########################################

"


read -p "What is a range partition? " response
answer="A range partition assigns a partition by determining if the partitioning key column is within a certain range and maps data to the partitions based on column values in its assigned partition."
evaluate_answer "$response" "$answer"



next_question




read -p "What is hash-based partitioning? " response
answer="Hash-based partitioning is applying a hash function to some key attributes of the entity being stored that yields the partition number."
evaluate_answer "$response" "$answer"



next_question



read -p "What is consistent hasing? " response
answer="Consistent Hashing maps data to physical nodes and ensures that only a small set of keys move when servers are added or removed."
evaluate_answer "$response" "$answer"




next_question




read -p "What is a replication factor? " response
answer="The replication factor is the number of nodes that will receive the copy of the same data."
additional_feedback="

        Correct.

        For example, a replication factor of two means there are two copies
        of each data item, where each copy is stored on a different node.

"
evaluate_answer "$response" "$answer" "$additional_feedback"



echo "
        ########################################
        #               Cache                  #
        ########################################

"


read -p "When the cache is full, and you want to replace a link with a newer/hotter URL, how would you choose? " response
answer="Least Recently Used policy. Under this policy, discard the least recently used URL first. Use a Linked Hash Map or a similar data structure to store our URLs and Hashes, which will also keep track of the URLs that have been accessed recently. "
evaluate_answer "$response" "$answer"




next_question




read -p "How can each cache replica be updated? "response
answer="Whenever there is a cache miss, update the cache and pass the new entry to all the cache replicas."
evaluate_answer "$response" "$answer"




next_question



read -p "Where are three places the load balancer can be positioned? " response
answer="Between Clients and Application servers. Between Application Servers and database servers. Between Application Servers and Cache servers."
evaluate_answer "$response" "$answer"




next_question



read -p "What is the benefit of the round-robin approach? " response
answer="Benefit of this approach is that if a server is dead, the load balancer will take it out of the rotation and stop sending any traffic to it."
evaluate_answer "$response" "$answer"


next_question



read -p "What are the disadvantages of the round-robin approach? " response
answer="A problem with round-robin approach is that if a server is overloaded or slow, the load balancer will not stop sending new requests to that server."
evaluate_answer "$response" "$answer"









 
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
        |                  TOPICS               | SCORE  |
        |---------------------------------------|--------- 
        |   Requirements and Goals Gathering    |        |   
        |---------------------------------------|---------
        |   Capacity Estimations and Constraints|        |
        |---------------------------------------|---------
        |   System APIs                         |        |   
        |---------------------------------------|---------
        |   Database Design                     |        |
        |---------------------------------------|---------
        |   Basic System Design and Algorithm   |        |   
        |---------------------------------------|---------
        |   Data Partitioning and Replication   |        |
        |---------------------------------------|---------
        |   Caching                             |        |
        |---------------------------------------|---------
        |   Loading Balancer                    |        |   
        |---------------------------------------|---------
        |   Purging or DB cleanup               |        |
        |---------------------------------------|---------

"
