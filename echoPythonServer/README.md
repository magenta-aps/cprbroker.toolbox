# Man In The Middle Logging tool 

This is a tool for inspection of http requests between 2 services.

The way is works, is that you start the program `python main.py`, you then
make your client request this program on the port specified.
This program then logs the request, and forwards the request to the real server
specified in the program in the variable `REALSERVERURL`, when the real server 
responds, it responds to this program, which will log the response before sending
it back to the client program.


