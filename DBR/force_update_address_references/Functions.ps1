# returns a string array with cpr numbers
function GetCprNumbersDttotalWithoutVejkod 
{
    Param (
        [array]$ConnectionMap
        )

    $DprEmuDbConStr = "Data Source=" + $ConnectionMap.DataSource + ";" +
            "Initial Catalog=" + $ConnectionMap.Initialcatalog + ";" +
            "User id=" + $ConnectionMap.UserId + ";" +
            "Password=" + $ConnectionMap.Password + ";"
 
    $connection = New-Object System.Data.SQLClient.SQLConnection
    $connection.ConnectionString = $DprEmuDbConStr
    $connection.Open()

    $Command = New-Object System.Data.SQLClient.SQLCommand
    $Command.Connection = $Connection
    $Command.CommandText = $("SELECT [PNR] FROM " + $ConnectionMap.Initialcatalog + ".[dbo].[DTTOTAL] WHERE VEJKOD = 0 AND STATUS = 01")
    $Reader = $Command.ExecuteReader()

    $CprNoArray = @()
    while ( $Reader.Read() ) 
    {
        $CprNo = $Reader.GetValue($0)

        if ($CprNo -match "^\d{9}$") 
        {
            $ZeroPrependedCprNo = "0$CprNo"
            $CprNoArray += ,$ZeroPrependedCprNo
        } 
        elseif ($CprNo -match "^\d{10}$") 
        {
            $CprNoArray += ,$CprNo
        } 
        else 
        {
            # Ignore everything else.
        }
    }
    $Connection.Close()

    return $CprNoArray
}

# Returns a dictionary {"<CprNo>":"<most_recent_extract_id>"}
function GetItemKeyArray 
{
    Param (
        [array]$ConnectionMap, 
        [array]$CprNoArray
        )

    $CprBrokerDbConStr = "Data Source=" + $ConnectionMap.DataSource + ";" +
            "Initial Catalog=" + $ConnectionMap.Initialcatalog + ";" +
            "User id=" + $ConnectionMap.UserId + ";" +
            "Password=" + $ConnectionMap.Password + ";"

    $Connection = New-Object System.Data.SQLClient.SQLConnection
    $Connection.ConnectionString = $CprBrokerDbConStr
    $Connection.Open()

    $Command = New-Object System.Data.SQLClient.SQLCommand
    $Command.Connection = $Connection

    $ItemKeyArray = @()
    foreach ($CprNo in $CprNoArray) 
    {
        $SqlQuery = $("SELECT TOP(1) [PNR], [Extract].[ExtractId]
                    FROM [" + $ConnectionMap.Initialcatalog + "].[dbo].[ExtractItem]
                    FULL OUTER JOIN [" + $ConnectionMap.Initialcatalog + "].[dbo].[Extract] " +
                        "on [" + $ConnectionMap.Initialcatalog + "].[dbo].[ExtractItem].[ExtractId] " +
                        "= [" + $ConnectionMap.Initialcatalog + "].[dbo].[Extract].[ExtractId]
                    WHERE PNR = '$CprNo'
                    ORDER BY [Extract].[ImportDate] DESC")

        $Command.CommandText = $SqlQuery
        
        $Reader = $Command.ExecuteReader()
        while ($Reader.Read()) 
        {
            $CprNo = $Reader.GetValue(0)
            $ExtractId = $Reader.GetValue(1)
            $ItemKey = "$Extractid|$CprNo"
            $ItemKeyArray += ,$ItemKey
        } 
        $Reader.close()
    }
    $Connection.Close()
    
    return $ItemKeyArray
}

function InsertIntoCprBrokerQueueItem 
{
    param(
        [array]$ConnectionMap,
        [string]$QueueId,
        [array]$ItemKeyArray
        )

        $CprBrokerDbConStr = "Data Source=" + $ConnectionMap.DataSource + ";" +
            "Initial Catalog=" + $ConnectionMap.Initialcatalog + ";" +
            "User id=" + $ConnectionMap.UserId + ";" +
            "Password=" + $ConnectionMap.Password + ";"

        $CurrentTime = Get-Date -UFormat "%Y-%m-%d %H:%M:%S:000"

        $Connection = New-Object System.Data.SQLClient.SQLConnection
        $Connection.ConnectionString = $CprBrokerDbConStr
        $Connection.Open()

        $Command = New-Object System.Data.SQLClient.SQLCommand
        $Command.Connection = $Connection

        foreach ($itemKey in $ItemKeyArray) {

            $SqlQuery = $("INSERT INTO [" + $ConnectionMap.Initialcatalog + "].[dbo].[QueueItem]
                        ([QueueId]
                        ,[ItemKey]
                        ,[CreatedTS]
                        ,[AttemptCount]
                        ,[SemaphoreId])
                    VALUES
                        ('$QueueId'
                        ,'$ItemKey'
                        ,'$CurrentTime'
                        ,0
                        ,NULL)")

            $Command.CommandText = $SqlQuery
            $Reader = $Command.ExecuteReader()         
            $Reader.close()
        }
        $Connection.Close()
       
}