function GetOldUuid 
{
    Param (
        [string]$cprNo,
        [array]$ConnectionMap
        )

    $pmDbConStr = "Data Source=" + $ConnectionMap.DataSource + ";" +
    "Initial Catalog=" + $ConnectionMap.Initialcatalog + ";" +
    "User id=" + $ConnectionMap.UserId + ";" +
    "Password=" + $ConnectionMap.Password + ";"

    $Connection = New-Object System.Data.SQLClient.SQLConnection
    $Connection.ConnectionString = $pmDbConStr
    
    $Connection.Open()

    $Command = New-Object System.Data.SQLClient.SQLCommand
    $Command.Connection = $Connection
    $Query = [string]::Format("SELECT [personMasterID] FROM [{0}].[dbo].[T_PM_CPR] WHERE [cprNo]='{1}' AND [inCprBroker]=1"
                                ,$ConnectionMap.Initialcatalog
                                ,$cprNo)

    $Command.CommandText = $Query   
    $Reader = $Command.ExecuteReader()    

    while ($Reader.Read()) 
    {
        return $Reader.GetValue($0)
    } 

    $Reader.close()
    $Connection.Close()
}