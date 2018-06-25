# Fake Data Provider For CPR Broker

This is a python script, which creates a TCP server on a specified port, 
the server will act like a CPR Direkte data provider for CPR Broker, always 
returning the data specified in the variable `MSG`.

This script will always return the MSG, no matter the data recieved, so it can 
*not* be used to test that the CPR Broker implementation is requesting correctly.