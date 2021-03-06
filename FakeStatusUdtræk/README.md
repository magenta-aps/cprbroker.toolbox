# Fake Status Udtræk

This file is a fake status udtræk generated from the CPr Broker test database.  
It contains 80 fake persons.  
It is used like any other status udtræk, by putting `udtraek.txt` in a folder on the CPR 
Broker server, and specifying the folder as the folder for the *CPR Extract*
data provider in CPR Broker, this will make CPR Broker look in the folder and 
import all the people to the CPr Broker database. 

`udtraek-with-lines.txt` is a file containing the same data, but with lines, to make it easier to transform the data if needed

udtraek was constructed with the following SQL Script:

```SQL
SELECT TOP (1000) MIN(ExtractItem.[Contents])
  FROM [CprBroker].[dbo].[PersonMapping]
  INNER JOIN dbo.PersonRegistration ON dbo.PersonRegistration.UUID = PersonMapping.UUID
  INNER JOIN dbo.[ExtractItem] ON PersonMapping.CprNumber = ExtractItem.PNR
    GROUP BY PNR, DataTypeCode
  ORDER By PNR
```
