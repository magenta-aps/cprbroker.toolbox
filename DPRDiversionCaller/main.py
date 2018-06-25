#!/usr/bin/env python
# Created by Jakob Rydhof (2018)
# Returns cpr data in the form CPR Direct proxy sends it
import socket

# Input the DPR Diversion information:
IP = "192.168.1.211"
PORT = 6001

InquiryType = "1"
# * DataNotUpdatedAutomatically = 0
# * DataUpdatedAutomaticallyFromCpr = 1
# * DeleteAutomaticDataUpdateFromCpr = 3

DetailType = "1"
# * MasterData = 0, // Only to client
# * ExtendedData = 1 // Put to DPR database

CprNumber = "1903059997"
# 10 digit cpr number, aka person registration number

MSG = str.encode(InquiryType + DetailType + CprNumber)
def main():
    print('Attempt to send request to:%s' % PORT)
    # create an INET, STREAMing socket
    clientsocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # connect t
    clientsocket.connect((IP,PORT))
    print("Client connected\r\n")

    totalsent = 0
    while totalsent < len(MSG):
        sent = clientsocket.send(MSG[totalsent:])
        if sent == 0:
            raise RuntimeError("socket connection broken")
        totalsent = totalsent + sent
    print("MSG: " + str(MSG) + " \r\nSent to server")


    print("response recieved")
    """while bytes_recd < MSGLEN:
        chunk = clientsocket.recv(min(MSGLEN - bytes_recd, 2048))
        if chunk == b'':
            raise RuntimeError("socket connection broken")
        chunks.append(chunk)
        bytes_recd = bytes_recd + len(chunk)"""
    print(str(clientsocket.recv(1000)))
    clientsocket.close()
        
if __name__ == "__main__":
    main()