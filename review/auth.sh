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

echo "
   ########################################
       Authentication and Authorization
   ########################################
"

read -p "Complete this sentence:

      OIDC stands for _________. It is an _______ protocol that verifies
      user identity when a user is trying to access a protected HTTPs end point.  

Enter your answer: " response

answer="OpenID Connect authentication"
additional_feedback="
    Correct. 

    OIDC stands for OpenID Connect. It is an authentication protocol that verifies
    user identity when a user is trying to access a protected HTTPs end point. 
"
evaluate_answer "$response" "$answer" "$additional_feedback"




next_question


read -p "What is the difference between authentication and authorization? " response

answer="Authentication confirms identity; authentication gives permission."
evaluate_answer "$response"  "$answer"


next_question


read -p "What does federated identity mean? " response
answer="Federated identity is the ability to link a user’s digital identity across separate security domains."
additional_feedback="
    Correct. 
    
    Federated identity is the ability to link a user’s digital identity 
    across separate security domains. 

"
evaluate_answer "$response" "$answer" "$additional_feedback"



next_question




read -p "Complete this sentence:

      When two applications are federated, a user can use one application by 
      _________ their identity with the other, without needing to ______ 
      _______ _______ and _______ for both.  

Enter your answer: " response

answer="authenticating create separate usernames and passwords"
additional_feedback="
    Correct. 
    
    When two applications are federated, a user can use one application by 
    authenticating their identity with the other, without needing to create 
    separate usernames and passwords for both.

"
evaluate_answer "$response" "$answer" "$additional_feedback"



next_question






read -p "What does IDP do? " response
answer="Identity provider (IDP) is the application responsible for performing authentication."
additional_feedback="
    Correct. 
    
    Identity provider (IDP) is the application responsible for performing authentication.

"
evaluate_answer "$response" "$answer" "$additional_feedback"



next_question






read -p "Considering the IDP model, if you create an account through Google 
         and separately attempt to log in to Firebase using that very same 
         Gmail address, will Firebase be able to locate your account?  " response

answer="No, because Firebase and Google are federated."
additional_feedback="
    Correct. 
    
    No, because Firebase and Google are federated - to gain access to Firebase, 
    you have to authenticate your identity through Google, not directly with Firebase.
"
evaluate_answer "$response" "$answer" "$additional_feedback"




next_question

read -p "What does SAML stand for? " response
answer="Security Assertion Markup Language"
additional_feedback="
    Correct. 
    
    SAML (Security Assertion Markup Language)

"
evaluate_answer "$response" "$answer" "$additional_feedback"




next_question

read -p "What is SAML? " response
answer="SAML is its own self-contained authentication and authorization protocol."
evaluate_answer "$response" "$answer"



next_question





read -p "Complete this sentence:

      ___________ (JWT) supply a _____ about the user - Ex: name and email. This is different 
      from an ______ _______, which does not include any identifiable information and instead 
      exists to __________ access to resource servers with limited scope. 

Enter your answer: " response

answer="JSON Web Token claim access token authorize"
additional_feedback="
    Correct. 

    JSON Web Token (JWT) supply a claim about the user - Ex: name and email. This is different 
    from an access token, which does not include any identifiable information and instead 
    exists to authorize access to resource servers with limited scope.

"
evaluate_answer "$response" "$answer" "$additional_feedback"




next_question

read -p "Complete this sentence:

      ___________ (JWT) supply a _____ about the user - Ex: name and email. This is different 
      from an ______ _______, which does not include any identifiable information and instead 
      exists to __________ access to resource servers with limited scope. 

Enter your answer: " response
answer="JSON Web Token claim access token authorize"
additional_feedback="
    Correct. 

    JSON Web Token (JWT) supply a claim about the user - Ex: name and email. This is different 
    from an access token, which does not include any identifiable information and instead 
    exists to authorize access to resource servers with limited scope.

"
evaluate_answer "$response" "$answer" "$additional_feedback"




next_question




read -p "Complete this sentence:

    _________ and _______ are how OAuth implements granular access controls. Together they 
    represent a _________________. The token is the ________ part and 
    the ______ defines ______________________. 

Enter your answer: " response

answer="scopes tokens permission to do something permission scope what it is that the user can do"
additional_feedback="
    Correct. 

    Scopes and tokens are how OAuth implements granular access controls. Together they 
    represent a permission to do something. The token is the permission part and 
    the scope defines what it is that the user can do.

"
evaluate_answer "$response" "$answer" "$additional_feedback"




next_question




read -p "How does IDP work? " response
answer="Client queries IDP and is redirected to an authorization prompt. IDP compatible with OIDC also becomes authentication prompt then an access token is issued."
additional_feedback="
    Correct. 

    When the client queries the IDP, the end-user (us) is redirected to an authorization prompt. 
    If the IDP is compatible with OIDC, this prompt also becomes the point of authentication, 
    after which the ID token is issued in the same step as the access token.

"
evaluate_answer "$response" "$answer" "$additional_feedback"




next_question






read -p "How does IDP work? " response
answer="Client queries IDP and is redirected to an authorization prompt. IDP compatible with OIDC also becomes authentication prompt then an access token is issued."
additional_feedback="
    Correct. 

    When the client queries the IDP, the end-user (us) is redirected to an authorization prompt. 
    If the IDP is compatible with OIDC, this prompt also becomes the point of authentication, 
    after which the ID token is issued in the same step as the access token.

"
evaluate_answer "$response" "$answer" "$additional_feedback"




next_question




read -p "OIDC defines a protected resource, called the _______ _______ " response
answer="UserInfo Endpoint"
additional_feedback="
    Correct. 

    OIDC defines a protected resource, called the UserInfo Endpoint.

"
evaluate_answer "$response" "$answer" "$additional_feedback"



next_question





read -p "What information is contained on UserInfo Endpoint? " response
answer="Claims about the user that can requested through standardized scopes and other OAuth scopes."
additional_feedback="
    Correct. 

    UserInfo Endpoint that contains common claims about the user that 
    can be requested through the use of standardized scopes and other OAuth scopes.

"
evaluate_answer "$response" "$answer" "$additional_feedback"



next_question



read -p "What are some user claims? " response
answer="sub = Subject iss = Issuer aud = Audience iat = Issue time exp = Expirytime"
additional_feedback="
    Correct. 

    sub = Subject
    iss = Issuer
    aud = Audience
    iat = Issue time
    exp = Expirytime

"
evaluate_answer "$response" "$answer" "$additional_feedback"



next_question




read -p "What is the purpose of OAuth? " response
answer="OAuth exists to provide third party applications limited access to secure resources without compromising the user’s data."
evaluate_answer "$response" "$answer"



next_question




read -p "In OAuth flow there are two components: the authorization server resource server. 

         How are they different?  

Enter your answer: " response
answer="Authorization server exists to validate and authorize the client whereas the resource server hosts the resources being requested."
evaluate_answer "$response" "$answer"



next_question




read -p "What are the four types of scopes?  " response
answer="Read Access Write Access Read and Write Access No Access"
evaluate_answer "$response" "$answer"



next_question





read -p "What are refresh tokens?  " response
answer="Refresh tokens are used to automatically obtain new access tokens when they are no longer functional."
evaluate_answer "$response" "$answer"



next_question






read -p "What are grants?  " response
answer="Grants dictate the order of operations for a client to obtain an access token. These unique orderings are called flows."
evaluate_answer "$response" "$answer"




next_question




read -p "For the resource server to know whether or not to honor a query for information, 
         it must know ______________.   " response

answer="if the requestor has been authorized"
evaluate_answer "$response" "$answer"



next_question




read -p "What is the relationship between the access token and the resource server?  " response
answer="The access token exists to inform the resource server that the requestor has been vetted by the authorization server and has permission to make the query."
evaluate_answer "$response" "$answer"



next_question






read -p "What is one benefit of access tokens?  " response
answer="Access tokens remove the need to provide credentials."
additional_feedback="
    Correct. 

    By using tokens as a proxy, the need for providing credentials is abstracted. 
    Access tokens are commonly issued as JWT Bearer Token.

"
evaluate_answer "$response" "$answer" "$additional_feedback"



next_question



read -p "How does Authorization Code Grant work?  " response
answer="The client receives a unique code issued by the authorization server, which is then exchanged for a token."
additional_feedback="
    Correct. 

    Authorization Code Grant is the most common grant type. By breaking up the steps 
    required to receive the token into two distinct queries, the authorization server 
    is able to verify important information about the client before issuing the token.
    
"
evaluate_answer "$response" "$answer" "$additional_feedback"




next_question




read -p "Describe an OAuth flow.  " response
answer="The application sends a request to the client. The client sends a grant to collect the data. Application will send the grant to an another applications's API.
The API server verifies the grant and sends an access token back the application. The application sends the access token to another API of the application.
The API sends the requested data to the applcation."
additional_feedback="
    Correct. 

    How does the oAuth flow work
    Spotify sends a message to Bob requesting the rights to access his public profile, 
    friend list, email and birthday.
    Bob provides Spotify with a grant to collect said data.
    Spotify sends the grant to a Facebook API.
    Facebook API verifies grant and sends an access token for Spotify to access protected resources.
    Spotify sends the access token to another Facebook API given by the authorization server.
    Facebook API sends the requested data to Spotify.
    
"
evaluate_answer "$response" "$answer" "$additional_feedback"


ESP validates a JWT in a performant way by using the JWT's issuer's 
public keys. ESP caches the public keys for five minutes. In addition, 
ESP caches validated JWTs for five minutes or until JWT expiry, 


Project identification — Identify the application or the project that's making a call to this API

Project authorization — Check whether the calling application has been granted 
access to call the API and has enabled the API in their project



You do want to block anonymous traffic. 
API keys identify an application's traffic for the API producer, 
in case the application developer needs to work with the API producer 
to debug an issue or show their application's usage.

You want to control the number of calls made to your API.

You want to identify usage patterns in your API's traffic. You can see 
application usage in APIs & services.

You want to filter logs by API key.
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
    echo "    You scored $score% on authentication and authorization."
fi

