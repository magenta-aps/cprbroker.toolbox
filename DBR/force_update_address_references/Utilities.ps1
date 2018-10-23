# returns System.Data.DataSet
function ProcessSelectQuery {
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