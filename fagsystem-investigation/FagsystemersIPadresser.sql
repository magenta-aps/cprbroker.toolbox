/*

This is an SQL script for combining a table generated from the IIS-log, 
with the IP-adresses of all requests, with the LogEntry table of CPR Broker.
It combines them by request time, being close to each other.
The second parameter in "DATEADD()" determines how far forward and backward it is searching.(in seconds)
It seems weird to look backward, as the requests to CPR Broker goes through the IIS, but somehow it 
found way more matches by looking backwards 1 second, i guess it might be a rounding thing.

*/

SELECT ALL
      [dbo].[LogEntry].[ApplicationId]
	    ,[dbo].[Application].[Name]     as ApplicationName
	    ,[dbo].[Fagsystemer-ip].[fagsystem-ip]
	    ,[RowId]
	    ,[dbo].[Fagsystemer-ip].[request-time]
      ,[LogDate]
      ,[UserToken]
      ,[UserId]
      ,[MethodName]
  FROM [dbo].[LogEntry]
  
  LEFT JOIN [dbo].[Application] 
	  ON [dbo].[Application].[ApplicationId] = [dbo].[LogEntry].[ApplicationId]
  RIGHT JOIN [dbo].[Fagsystemer-ip] 
    ON  [MethodName] != ''
    AND [dbo].[LogEntry].[LogDate] 
      between DATEADD(ss,-1,[dbo].[Fagsystemer-ip].[request-time]) and DATEADD(ss,2,[dbo].[Fagsystemer-ip].[request-time])

  ORDER BY [request-time] DESC
