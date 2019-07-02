function update_personmapping_uuids
{
    Param (
        [string]$cprNo,
        [string]$originalUuid,
        [array]$connectionMap
        )

    $dbConStr = "Data Source=" + $connectionMap.DataSource + ";" +
    "Initial Catalog=" + $connectionMap.Initialcatalog + ";" +
    "User id=" + $connectionMap.UserId + ";" +
    "Password=" + $connectionMap.Password + ";"

    $Connection = New-Object System.Data.SQLClient.SQLConnection
    $Connection.ConnectionString = $dbConStr
    
    $CommandString = "dbo.UpdatePersonUuid"

    $Command = New-Object System.Data.SqlClient.SqlCommand
    $Command.CommandType = [System.Data.CommandType]::StoredProcedure
    $Command.CommandText = $CommandString
    $Command.Connection = $Connection


    $Command.Parameters.Add("@cprNo",[system.data.SqlDbType]::String) | out-Null
    $Command.Parameters['@cprNo'].Direction = [system.data.ParameterDirection]::Input
    $Command.Parameters['@cprNo'].value = $cprNo


    $Command.Parameters.Add("@uuid",[system.data.SqlDbType]::String) | out-Null
    $Command.Parameters['@uuid'].Direction = [system.data.ParameterDirection]::Input
    $Command.Parameters['@uuid'].value = $originalUuid


    $Connection.Open()

    $Command.ExecuteNonQuery()

    $Reader = $Command.ExecuteReader()    
  
    while ($Reader.Read()) 
    {
        Write-Host $Reader.GetValue($0)
    } 

    $Reader.close()

    $Connection.Close()
}