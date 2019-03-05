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


$fileWithCprnoNewUuids = $ConfigFile.Settings.Paths.NewPersonmaster
$fileWithCprnoNewAndOldUuids = $ConfigFile.Settings.Paths.OldPersonmaster

New-Item -Path . -Name $fileWithCprnoNewAndOldUuids -ItemType "file"

$count = 0
foreach($line in [System.IO.File]::ReadLines($fileWithCprnoNewUuids)) 
{
    $cprNo = $line.substring(0,10)
    $originalUuid = GetOldUuid -cprNo $cprNo -ConnectionMap $pmDbConMap
    try 
    {
        $line_increment = [string]::Format("$line,{0}", $originalUuid)
        Add-Content -Path $fileWithCprnoNewAndOldUuids -Value $line_increment
    }
    catch 
    {
        $line_increment = [string]::Format("$line,{0}", "NO MATCH")
        Add-Content -Path $fileWithCprnoNewAndOldUuids -Value $line_increment
    }
    $count += 1
    Write-Host $count
}
