#!/usr/bin/env python
# Created by Jakob Rydhof (2017)
# Returns cpr data in the form CPR Direct proxy sends it
import socket
from time import sleep

PORT = 7779
MSG = str.encode("463006R0OGN9GFWUCP1170001309000000000000046300420171121000000000011903059997          01000000000000 M2005-03-19 2005-03-19                                              002190305999701590626304 stD-53                                      201705152202 201705152202 0101201705152202                                                                                                                                                                                                   0031903059997Adam Jensen                                                                                          Nybrovej 304,st,-D-53                                               2800Kgs. Lyngby         01590626304 stD-53    Nybrovej            004190305999700032017-08-242117-08-240081903059997Adam                                                                                       Jensen                                   200508200927 Adam Jensen                      00919030599977089                    01019030599975100200503190818 0111903059997F2005-08-20 0121903059997U                                                        000000000000             01519030599972005-03-19*1303814074                                              2005-03-19*0712614455                                              999999999999900000010")

def main():
    print('Listening on localhost:%s' % PORT)
    # create an INET, STREAMing socket
    serversocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    # bind the socket to a public host, and a well-known port
    serversocket.bind(('127.0.0.1', PORT))
    # become a server socket
    serversocket.listen(5)
    serversocket.settimeout(5)
    while True:
        try:
            (clientsocket, address) = serversocket.accept()
            
            clientsocket.settimeout(0.1)
            print("Client connected\r\n")
        
            chunks = ""
            bytes_recd = 0

            chunk = getFromSocket(clientsocket)
            counter = 0 
            # we will recieve a maximum of 1000 bytes.
            # to ensure the program does not hang here.
            while chunk != None and counter < 1000:
                chunks += (chunk.decode())
                bytes_recd = bytes_recd + 1
                chunk = getFromSocket(clientsocket)
                counter += 1
            print("Chunks recieved: "+chunks)

            totalsent = 0
            while totalsent < len(MSG):
                sent = clientsocket.send(MSG[totalsent:])
                if sent == 0:
                    raise RuntimeError("socket connection broken")
                totalsent = totalsent + sent
            

        except socket.timeout as e:
            print("Socket timeout reached - this is made as an escape, so keyboard interupt can work(ctrl-c)")

        
def getFromSocket(clientsocket):
    try:
        return clientsocket.recv(1)
    except socket.timeout as e:
        return None


if __name__ == "__main__":
    main()