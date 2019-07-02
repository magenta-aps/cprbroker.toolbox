. .\Functions.ps1

[xml]$ConfigFile = Get-Content "./Settings.xml"

$src = $ConfigFile.Settings.Database.CprBroker.Source
$db = $ConfigFile.Settings.Database.CprBroker.InitialCatalog
$usr = $ConfigFile.Settings.Database.CprBroker.UserId
$pwd = $ConfigFile.Settings.Database.CprBroker.Password

$dbConMap = @{"DataSource" = $src; 
                "InitialCatalog" = $db;
                "UserId" = $usr;
                "Password"= $pwd}

$fileWithCprnoandOldUuids = $ConfigFile.Settings.Paths.OldCprBroker

$count = 0
foreach($line in [System.IO.File]::ReadLines($fileWithCprnoandOldUuids)) 
{
    $line_arr = $line.Split(",") # <-- FILE DELIMETER !
    $cprNo = $line_arr[0]
    $originalUuid = $line_arr[1]
    try 
    {
        if ($originalUuid.length -gt 35) # Length should be 36 chars.
        {
            update_personmapping_uuids -cprNo $cprNo -originalUuid $originalUuid -connectionMap $dbConMap
            #$consoleOut = [string]::Format("Count: {0} - cprNo {1} - ordiginalUuid {2}", $count, $cprNo , $originalUuid)
            $count += 1
            Write-Host $count
        }
    }
    catch 
    {
        $ErrorMessage = $_.Exception.Message
        Write-Host $ErrorMessage
        #New-Item -Path . -Name "error.log" -ItemType "file"
        #Add-Content -Path "error.log" -Value $ErrorMessage
    }
}