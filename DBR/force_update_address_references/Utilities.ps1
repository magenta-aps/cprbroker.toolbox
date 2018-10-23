# returns a string array with cpr numbers
function GetCprNumbersDttotalWithoutVejkod {
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

    $cpr_no_array = @()
    while ($Reader.Read()) {

        $cpr_no = $Reader.GetValue($0)

        if ($cpr_no -match "^\d{9}$") {

            $zero_prepended_cpr_no = "0$cpr_no"
            $cpr_no_array += ,$zero_prepended_cpr_no

        } elseif ($cpr_no -match "^\d{10}$") {

            $cpr_no_array += ,$cpr_no

        } else {
            # Ignore everything else.
        }
    }
    $Connection.Close()

    return $cpr_no_array
}



# Generic write to db function instead?
function InsertIntoCprBrokerQueueItem {
    Param (
        [string]$queue_id,
        [string]$item_key,
        [string]$created_ts,
        [string]$attempt_count,
        [string]$semaphore_id,
        [string]$connection_string
    )
}