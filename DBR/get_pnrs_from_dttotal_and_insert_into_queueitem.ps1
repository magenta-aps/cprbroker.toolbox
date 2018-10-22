# returns System.Data.DataSet
function Read-From-DB {
    Param (
        [string]$connection_string,
        [string]$sql_query
    )

    $connection = New-Object System.Data.SQLClient.SQLConnection
    $connection.ConnectionString = $connectionString
    $connection.Open()
    $Command = New-Object System.Data.SQLClient.SQLCommand
    $Command.Connection = $Connection
    $Command.CommandText = $sql_query
    $Reader = $Command.ExecuteReader()
    while ($Reader.Read()) {
         $Reader.GetValue($0) 
    }
    $Connection.Close()
}

# Read-From-DB duplicate ????
function Get-Latest-ExtractId-From-CprBroker-Extract {
    Param (
        [string]$pnr,
        [string]$connection_string
    )
}

# Generic write to db function instead?
function Insert-Into-CprBroker-QueueItem {
    Param (
        [string]$queue_id,
        [string]$item_key,
        [string]$created_ts,
        [string]$attempt_count,
        [string]$semaphore_id,
        [string]$connection_string
    )
}

###############################################
### FETCHING CPR NUMBERS FROM DPR EMULATION ###
###############################################

$dpr_emu_src = ""
$dpr_emu_db = ""
$dpr_emu_usr = ""
$dpr_emu_pwd = ""
$dpr_emu_cmd = $("SELECT [PNR] FROM $dpr_emu_db.[dbo].[DTTOTAL] WHERE VEJKOD = 0 AND STATUS = 01")

$connectionString = "Data Source='$dpr_emu_src';" +
            "Initial Catalog='$dpr_emu_db';" +
            "User id='$dpr_emu_usr';" +
            "Password='$dpr_emu_pwd';"

$result_dttotal = Read-From-Db -connection_string $connectionString, -sql_query $dpr_emu_cmd

$pnr_array = @()

foreach($pnr in $result_dttotal)
{
    # TODO:
    # If the line is 9 digits we have identified a PNR
    # that begins with zero; except that the zero has been removed
    # due to a person number being of type int the DPR data model.
    # If the line is 10 digits we just add it to the array.
    
    $pnr_array += ,$pnr   
}

foreach($pnr in $pnr_array)
{
    # TODO:
    # Get-Latest-ExtractId-From-CprBroker-Extract()
    # insert row into CprBroker   
}