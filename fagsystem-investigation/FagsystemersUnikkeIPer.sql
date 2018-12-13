/*

This SQL script 

*/

SELECT DISTINCT 
	  KIT_CprBroker.dbo.Application.Name as ApplicationName
	  ,[KIT_CprBroker].[dbo].[Fagsystemer-ip].[fagsystem-ip]
  FROM [KIT_CprBroker].[dbo].[LogEntry]
  
  LEFT JOIN KIT_CprBroker.dbo.Application 
	ON KIT_CprBroker.dbo.Application.ApplicationId = [KIT_CprBroker].[dbo].[LogEntry].ApplicationId
  RIGHT JOIN [KIT_CprBroker].[dbo].[Fagsystemer-ip] 
	ON  MethodName != ''
	AND KIT_CprBroker.[dbo].[LogEntry].LogDate 
		between DATEADD(ss,-1,[KIT_CprBroker].[dbo].[Fagsystemer-ip].[request-time]) and DATEADD(ss,2,[KIT_CprBroker].[dbo].[Fagsystemer-ip].[request-time])

  ORDER BY [fagsystem-ip]