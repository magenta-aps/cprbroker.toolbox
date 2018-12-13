
This is a few powershell one-liners to get ip information from the IIS-logs on requests 
to Part interface. Unfortunately powershell does not work well with input and output.
So the script must be copy-pasted into a powershell terminal.

Usage:
Navigate to the folder with CPRBrokers IIS logs (C:\\inetpub\\logs\LogFiles\\{SOMETHING})
Copy this line into powershell
enter
read the newly generated file *ip-from-logs.csv* and move it to an appropriate folder.
``` 
cat * | Select-String -Pattern "^[^/]*/services/part.asmx.*" | %{$_ -replace "^(\S*\s\S*)\s(\S*)\s\S*\s/services/part.asmx\s-\s(\S*)\s-\s(\S*).*$",'$1;$2;$3;$4'} > ip-from-logs.csv
```

Remove local ip-requests (This might not be important if it is inserted into a SQL table):
```
cat .\ip-from-logs.csv | Select-String -NotMatch -Pattern "127.0.0.1;[0-9]*;127.0.0.1" | Select-String -NotMatch -Pattern "::1;[0-9]*;::1" > ip-from-logs-2.csv
```

Changing time format for SQL:
```
cat .\ip-from-logs-2.csv | %{$_ -replace "(\d\d:\d\d:\d\d)",'$1.000'} > .\ip-from-logs-3.csv
```

Making it ready to be used in a SQL INSERT INTO Statement:
```
 cat .\ip-from-logs-3.csv | %{$_ -replace "^","('"} | %{$_ -replace ";","','"} | %{$_ -replace "$","'),"} > .\ip-from-logs-4.csv
```

TODO Write insert SQL Statement(not done):
```SQL
INSERT INTO [dbo].[Fagsystemer-ip] 
-- should add an ID for each row, for the user to be able to see unique requests.

```