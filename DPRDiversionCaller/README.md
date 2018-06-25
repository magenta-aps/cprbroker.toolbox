# DPR Diversion Caller

This is a small python script, which calls a running server instance of DPR 
Diversion. It has only been tested on the CPR Broker emulation, but should be
the same interface as a real one.

The code to be modified is the following at the top of the file:
``` python
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
```