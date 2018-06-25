#!/usr/bin/env python
# Reflects the requests from HTTP methods GET, POST, PUT, and DELETE
# Written by Nathan Hamiel (2010)
# 
# Changed to forward all requests to a specified server, 
# and forward responses back to the caller,
# while logging all requests and responses
# Updated by Jakob Rydhof (2017)

#from BaseHTTPServer import HTTPServer, BaseHTTPRequestHandler
from http.server import HTTPServer, BaseHTTPRequestHandler
from optparse import OptionParser
from http.client import HTTPSConnection, HTTPConnection
import socket
import xml.dom.minidom

# This is the domain of the real server, which should be requested.
REALSERVERURL = "cprbroker"
# Only the domain/ip+port should be specified here, the specific 
# paths ( /index.html ), are specified in the requests themself.


# This is the port this server is requested at
PORT = 8080

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
        print("\n----- Request From Client Start ----->\n")
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
        print("<----- Request From Client End ----->\n\n\n")

        # Build request to real server
        # connection = HTTPSConnection(REALSERVERURL,443)
        connection = HTTPConnection(REALSERVERURL,80)

        # Rewrite the header to a format which can be used in a request
        new_req_header = {}
        for (header,data) in request_headers.items():
            new_req_header[header]=data
        new_req_header["Host"] = REALSERVERURL # Overwrites the Host header to the real host

        connection.request(request_method, request_path, body=request_content, headers=new_req_header)

        response = connection.getresponse()
        response_content = response.read()


        # Print response from the real server
        print("<----- Response From Server Start ----->\n")
        print("Status code: ",response.status, response.reason)
        print("Response Headers:")
        for (header,data) in response.getheaders():
            print(header+": "+data)
        print()
        print("Body:")
        response_content_xml = xml.dom.minidom.parseString(response_content)
        print(response_content_xml.toprettyxml())
        print("<----- Response From Server End ----->\n")

        # Build headers
        self.send_response(response.status)
        for (header,data) in response.getheaders():
            self.send_header(header,data)

        # Respond the client with the response from the real server    
        self.end_headers()
        self.wfile.write(response_content)

    
    
    do_PUT = do_GET
    do_DELETE = do_GET
    do_POST = do_GET
        
def main():
    print('Listening on localhost:%s' % PORT)
    server = HTTPServer(('', PORT), RequestHandler)
    server.serve_forever()

        
if __name__ == "__main__":
    parser = OptionParser()
    parser.usage = ("Creates an http-server that will echo out any GET or POST parameters\n"
                    "Run:\n\n"
                    "   reflect")
    (options, args) = parser.parse_args()
    
    main()