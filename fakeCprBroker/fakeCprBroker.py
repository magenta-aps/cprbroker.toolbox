#!/usr/bin/env python
# 
# Serve a static xml file as the response to any request
# Updated by Jakob Rydhof (2017)

# Based on: https://gist.github.com/ethack/874956896344998c1f57
# Reflects the requests from HTTP methods GET, POST, PUT, and DELETE
# Written by Nathan Hamiel (2010)

#from BaseHTTPServer import HTTPServer, BaseHTTPRequestHandler
from http.server import HTTPServer, BaseHTTPRequestHandler
from optparse import OptionParser
from http.client import HTTPSConnection, HTTPConnection
import socket
import xml.dom.minidom

PORT = 8080

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

class RequestHandler(BaseHTTPRequestHandler):
    
    def do_GET(self):
        
        print("#####################################")
        print("############# Request ###############")
        print("#####################################")
        
        # Define variables from the request
        request_path = self.path
        request_headers = self.headers
        request_method = self.command
        content_length = request_headers['Content-Length']
        length = int(content_length) if content_length else 0
        request_content = self.rfile.read(length)
        
        # Print info from request
        print("\n----- Start Request From Client ----->\n")
        print("Request Path: ",request_method,request_path)
        print("Headers:")
        print(request_headers)
        print("Body:")
        try:
            request_content_xml = xml.dom.minidom.parseString(request_content)
            print(request_content_xml.toprettyxml())
        except xml.parsers.expat.ExpatError:
            print(request_content)
        print()
        print("<----- End Request From Client ----->\n\n\n")


        req = request_content.decode("utf-8")

        responseChoice(self,req)

    
    do_PUT = do_GET
    do_DELETE = do_GET
    do_POST = do_GET
        

def respond(o,response):
        
    # Build headers
    o.send_response(200)

    o.send_header("Content-Length", len(response))
    o.send_header("Content-Type","application/soap+xml; charset=utf-8")  
    o.end_headers()

    # Respond the client with the response from the file
    o.wfile.write(response)


def main():
    print('Listening on localhost:%s' % PORT)
    server = HTTPServer(('', PORT), RequestHandler)
    server.serve_forever()

        
if __name__ == "__main__":
    parser = OptionParser()
    parser.usage = ("Creates an http-server that will serve the response specified in an acompanying file\n"
                    "Run:\n\n"
                    "   reflect")
    (options, args) = parser.parse_args()
    
    main()