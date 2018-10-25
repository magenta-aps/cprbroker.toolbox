# Force Update Address References in [DprEMulationDb].[dbo].[DTTOTAL]

## Purpose
To force an update of address references in **[DprEMulationDb].[dbo].[DTTOTAL]**.

## How does the tool work?
Retrieves all **_PNR_** from **[DprEmulationDb].[dbo].[DTTOTAL]** where **_VEJKOD_** is *0*. The value *0* means that the given person does not have an address reference. 
For each cpr number to create an **_ItemKey_** based on joined data from **[CprBrokerDb].[dbo].[ExtractItem]** and **[CprBrokerDb].[dbo].[Extract]**.
The tool then uses **_ItemKey_** to insert rows into **[CprBrokerDb].[dbo].[QueueItem]**. 
Bear in mind that there might not always be a valid adress reference in **[CprBrokerDb].[dbo].[ExtractItem]** in relation to the latest **_ExtractId_**. Sometimes people don't have an address, e.g. newborns, foreigners, etc.

## How does one use the tool?
Rename, or copy _Settings.xml.example_ to _Settings.xml_. Populate the values og the elements in _Settings.xml_. 
The value for the element **_QueueId_** is supposed to be the reference to the DBR Queue Id. Your can find it in **[CprBrokerDb].[dbo].[QueueItem].[QueueId]** of the **_TypeName_** **CprBroker.DBR.DbrQueue, CprBroker.DBR**.
Now run **.\ForceUpdateAddressReferences.ps1** from a Powershell Terminal as Administrator.
