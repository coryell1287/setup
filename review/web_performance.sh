Loss-less compression, where the compression-uncompression cycle doesn't 
alter the data that is recovered. It matches (byte to byte) with the original. 
For images, gif or png are using lossless compression.


Lossy compression, where the cycle alters the original data in a (hopefully) imperceptible 
way for the user. Video formats on the Web are lossy; the jpeg image format is also lossy.

End-to-end compression refers to a compression of the body of a message that is done by the 
server and will last unchanged until it reaches the client. Whatever the intermediate nodes are, 
they leave the body untouched.


In the 1990s, compression technology was advancing at a rapid pace and numerous successive 
algorithms have been added to the set of possible choices. Nowadays, only two are relevant:
gzip, the most common one, and br the new challenger.


Hop-by-hop compression, though similar to end-to-end compression, differs by one fundamental 
element: the compression doesn't happen on the resource in the server, creating a specific 
representation that is then transmitted, but on the body of the message between any two nodes 
on the path between the client and the server. Connections between successive intermediate nodes 
may apply a different compression.


 TE and Transfer-Encoding are mostly used to send a response by chunks, allowing to start 
 transmitting a resource without knowing its length.


additional info
Note that using Transfer-Encoding and compression at the hop level is so 
rare that most servers, like Apache, Nginx, or IIS, have no easy way to configure it. Such
 configuration usually happens at the proxy level