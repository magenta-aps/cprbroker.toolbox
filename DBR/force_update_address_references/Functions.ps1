# Downloads data files from cpr.dk
function DownloadPostDistrictAndGeoLocationFiles
{
    Param([array]$uriList)

    New-Variable -Name "DOWNLOAD_PATH" -Value "Download" -Option Constant
    $downloadPath = [string]::Format("{0}\{1}", $PSScriptRoot, $DOWNLOAD_PATH)
    New-Item -ItemType Directory -Force -Path $downloadPath

    $wc = New-Object System.Net.WebClient

    foreach ($uri in $uriList)
    {
        try {
            Write-Host ("Trying to download file from " + $uri)
            $filename = $uri.substring($uri.lastIndexOf('/') + 1);
            $wc.DownloadFile($uri, ($downloadPath + "\" + $filename))
        }
        catch [Net.WebException] 
        {
            Write-Host $_.Exception.ToString()
            Write-Host "Exiting program..."
            exit
        }
    }
}

function ProcessPostDistrictAndGeoLocationFiles
{
    # Move partial logic from ./playground.ps1 here.
}

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

# Returns an array item keys. ItemKey = "ExtractId|CprNumber"
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