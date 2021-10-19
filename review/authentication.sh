OIDC stands for “OpenID Connect”. It is an authentication protocol which allows to verify
user identity when a user is trying to access a protected HTTPs end point. 




Authentication Confirms Identity Authorization Gives Permission


“federated identity” is the ability to link a user’s digital identity 
across separate security domains. 

In other words, when two applications are 
“federated,” a user can use one application by authenticating their identity with the other, 
without needing to create separate usernames/passwords for both.




Identity provider (IDP) is the application responsible for performing authentication.


Considering the IDP model, if you create an account through Google and separately attempt to 
log in to Firebase using that very same Gmail address,  will Firebase be able to locate your account? 


No, because Firebase and Google are federated - to gain access to Firebase, you have to authenticate 
your identity through Google, not directly with Firebase.

When you sign in with your Google account (IDP), Firebase does not create a new 
account using the traditional username/password authentication pattern.




SAML (Security Assertion Markup Language)


SAML is its own self-contained authentication and authorization protocol.



applications using OIDC work with any identity provider that supports the protocol.



JSON Web Token (JWT). supply a claim about the user - Ex: name and email. This is different 
from an access token, which does not include any identifiable information and instead 
exists to authorize access to resource servers with limited scope.



Scopes and tokens are how OAuth implements granular access controls. 
Together they represent a “permission to do something.” The token is the “permission” 
part and the scope defines what it is that the user can do.
# if this is not detailed enough remove it

When the client queries the IDP, the end-user (us) is redirected to an authorization prompt. 
If the IDP is compatible with OIDC, this prompt also becomes the point of authentication, 
after which the ID token is issued in the same step as the access token.


OIDC defines a protected resource, called the UserInfo Endpoint, that contains common 
information about the user that can be requested through the use of standardized scopes 
and other OAuth scopes. The only mandatory scope when using OIDC is the openid. This is the 
parameter that signals an OIDC-compatible IDP to issue an ID token along with the access token.
This ID token, just like the access token, is a JWT. 


user claims
sub = Subject
iss = Issuer
aud = Audience
iat = Issue time
exp = Expirytime



OAuth exists to provide third party applications limited access
to secure resources without compromising the user’s data.


How does the oAuth flow work
Spotify sends a message to Bob requesting the rights to access his public profile, 
friend list, email and birthday.
Bob provides Spotify with a grant to collect said data.
Spotify sends the grant to a Facebook API.
Facebook API verifies grant and sends an access token for Spotify to access protected resources.
Spotify sends the access token to another Facebook API given by the authorization server.
Facebook API sends the requested data to Spotify.


In OAuth flow there are two components: the authorization server resource server. How are they different? 

authorization server exists to validate and authorize 
the client whereas the resource server hosts the resources being requested. 
For the resource server to know whether or not to honor a query for information, 
it must know if the requestor has been authorized. This is where the access token comes in; 
it exists to inform the resource server that the requestor has been vetted by the authorization 
server and has permission to make the query. By using tokens as a proxy, the need for providing
credentials is abstracted. Access tokens are commonly issued as JWT Bearer Token.


What are the scopes resources will define
there are four types of scopes:

Read Access
Write Access
Read and Write Access
No Access


Refresh tokens are used to automatically obtain new access tokens when they are 
no longer functional (eg. Expired).

Grants dictate the order of operations for a client to obtain an access token. 
These unique orderings are called flows.

What would the example of a flow?
Navigate to theater webpage
Select showtime
Check out cart
Enter payment information
Obtain digital ticket through email


Confidential clients can be trusted to securely hold the token, which is necessary for accessing resources.
Such clients may include server-side applications. Public clients cannot be trusted to store 
client credentials. These types of clients include mobile or Javascript browser applications.


Authorization Code Grant_ _- Authorization code grants are perhaps the most common grant 
type (see Figure 4). In essence, the client receives a unique code issued by the authorization 
server, which is then exchanged for a token. By breaking up the steps required to receive the token 
into two distinct queries, the authorization server is able to verify important information about the 
client before issuing the token.


Authorization Code Grant with PKCE Extension - This variant of the authorization code grant 
is used for public clients that cannot be trusted to store credentials. Using the PKCE extension 
(Public Key for Code Exchange), the client and servers transfer a hash to verify that communications 
are not intercepted.


The client will make a request that will include parameters ‘client_id’ and ‘client_secret’, 
which the authorization server can verify to issue access tokens. 
This type of grant should only be used with confidential clients and must be registered first.