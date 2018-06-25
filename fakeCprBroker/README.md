# Fake CPR Broker

This is a small python script for making fake responses from CPR Broker.  
The `PORT` variable specifies the port to run the server on.  

The following code reads some files specified.  
These files are used as responses to different requests.
``` python
# Files containing the responses
LI = open("LaesInput.xml",'rb').read()
uuid = open("UUID.xml", 'rb').read()
lists = open("list1.xml", 'rb').read()
addr = open("ADDR.xml",'rb').read()

# This code makes the choice of which respond to send.
def responseChoice(o,req):
    if "GetUuid" in req:
        respond(o,uuid)

    elif "LaesInput" in req:
        respond(o,LI)

    elif "ListInput" in req:
        respond(o,lists)
    
    elif "SearchList" in req:
        respond(o,addr) 
```

