function update_T_PM_PersonMaster_objectID
{
    Param (
        [string]$newUuid,
        [string]$originalUuid,
        [array]$connectionMap
        )

    $pmDbConStr = "Data Source=" + $connectionMap.DataSource + ";" +
    "Initial Catalog=" + $connectionMap.Initialcatalog + ";" +
    "User id=" + $connectionMap.UserId + ";" +
    "Password=" + $connectionMap.Password + ";"

    $Connection = New-Object System.Data.SQLClient.SQLConnection
    $Connection.ConnectionString = $pmDbConStr
    
    $Connection.Open()

    $Command = New-Object System.Data.SQLClient.SQLCommand
    $Command.Connection = $Connection
    $Query = [string]::Format("UPDATE [dbo].[T_PM_PersonMaster] SET [objectID] = '{0}' WHERE [objectID] = '{1}'"
                                ,$originalUuid
                                ,$newUuid)

    $Command.CommandText = $Query   
    $Reader = $Command.ExecuteReader()    

    while ($Reader.Read()) 
    {
        return $Reader.GetValue($0)
    } 

    $Reader.close()
    $Connection.Close()
}