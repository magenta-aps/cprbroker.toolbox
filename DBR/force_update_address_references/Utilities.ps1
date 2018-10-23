# returns a string array with cpr numbers
function GetCprNumbersDttotalWithoutVejkod {
    Param ( [array]$ConnectionMap )

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
    while ($Reader.Read()) {

        $CprNo = $Reader.GetValue($0)

        if ($CprNo -match "^\d{9}$") {

            $ZeroPrependedCprNo = "0$CprNo"
            $CprNoArray += ,$ZeroPrependedCprNo

        } elseif ($CprNo -match "^\d{10}$") {

            $CprNoArray += ,$CprNo

        } else {
            # Ignore everything else.
        }
    }
    $Connection.Close()

    return $CprNoArray
}

# Returns a dictionary {"<CprNo>":"<most_recent_extract_id>"}
function GetCprNoAndExtractIdMap {
    Param ( [array]$connectionMap, [array]$CprNoArray )

    $CprBrokerDbConStr = "Data Source=" + $ConnectionMap.DataSource + ";" +
            "Initial Catalog=" + $ConnectionMap.Initialcatalog + ";" +
            "User id=" + $ConnectionMap.UserId + ";" +
            "Password=" + $ConnectionMap.Password + ";"

    #$connection = New-Object System.Data.SQLClient.SQLConnection
    #$connection.ConnectionString = $CprBrokerDbConStr
    #$connection.Open()

    # $Command = New-Object System.Data.SQLClient.SQLCommand
    # $Command.Connection = $Connection

    # $cpr_and_extract_id_dict = @{}
    # foreach ($CprNo in $CprNoArray) {

    #     $Command.CommandText = $("SELECT TOP(1) [PNR], [Extract].[ExtractId]
    #     FROM $cprbroker_src.[dbo].[ExtractItem]
    #     FULL OUTER JOIN $cprbroker_src.[dbo].[Extract] on $cprbroker_src.[dbo].[ExtractItem].[ExtractId] = $cprbroker_src.[dbo].[Extract].[ExtractId]
    #     WHERE PNR = $CprNo
    #     ORDER BY [Extract].[ImportDate] DESC")
        
    #     $Reader = $Command.ExecuteReader()
        
    #     while ($Reader.Read()) {
    #         $CprNo = $Reader.GetValue($0)
    #         $extract_id = $Reader.GetValue($1)
    #         $cpr_and_extract_id_dict.Add($CprNo, $extract_id)
    #     } 
    # }
    # $Connection.Close()
    # $cpr_extract_id_dict
    #return $cpr_extract_id_dict
}