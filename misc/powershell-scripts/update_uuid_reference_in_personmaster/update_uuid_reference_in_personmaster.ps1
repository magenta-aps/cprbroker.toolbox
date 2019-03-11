. .\Functions.ps1

[xml]$ConfigFile = Get-Content "./Settings.xml"

$pmSrc = $ConfigFile.Settings.Database.PersonMaster.Source
$pmDb = $ConfigFile.Settings.Database.PersonMaster.InitialCatalog
$pmUsr = $ConfigFile.Settings.Database.PersonMaster.UserId
$pmPwd = $ConfigFile.Settings.Database.PersonMaster.Password

$pmDbConMap = @{"DataSource" = $pmSrc; 
                "InitialCatalog" = $pmDb;
                "UserId" = $pmUsr;
                "Password"= $pmPwd}


$fileWithCprnoNewAndOldUuids = $ConfigFile.Settings.Paths.OldPersonmaster

$count = 0
foreach($line in [System.IO.File]::ReadLines($fileWithCprnoNewAndOldUuids)) 
{
    $line_arr = $line.Split(",")
    $newUuid = $line_arr[1]
    $originalUuid = $line_arr[2]
    try 
    {
        # Update (PK)[T_PM_CPR].[objectID] <-- (FK)[T_PM_CPR].[personMasterID]
        if ($originalUuid.length -gt 35) # Length should be 36 chars.
        {
            update_T_PM_PersonMaster_objectID -newUuid $newUuid -originalUuid $originalUuid -connectionMap $pmDbConMap
            $consoleOut = [string]::Format("Count: {0} - objectID {1} changed to {2}", $count, $newUuid ,$originalUuid, $mssqlResponse)
            $count += 1
            Write-Host $consoleOut
        }
    }
    catch 
    {
        $ErrorMessage = $_.Exception.Message
        New-Item -Path . -Name "error.log" -ItemType "file"
        Add-Content -Path "error.log" -Value $ErrorMessage
    }
}