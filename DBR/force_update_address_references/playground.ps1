. .\Functions.ps1

[xml]$ConfigFile = Get-Content "./Settings.xml"

Write-Host "             _            _                 _            _ _             "
Write-Host " __ _ __ _ _| |__ _ _ ___| |_____ _ _      | |_ ___  ___| | |__  _____ __"
Write-Host "/ _| '_ \ '_| '_ \ '_/ _ \ / / -_) '_|  _  |  _/ _ \/ _ \ | '_ \/ _ \ \ /"
Write-Host "\__| .__/_| |_.__/_| \___/_\_\___|_|   (_)  \__\___/\___/_|_.__/\___/_\_\"
Write-Host "   |_|                                                                 \n"

New-Variable -Name "DOWNLOAD_FOLDER" -Value $ConfigFile.Settings.DownloadFolder -Option Constant
$downloadPath = [string]::Format("{0}\{1}", $PSScriptRoot, $DOWNLOAD_FOLDER)

Write-Host ([string]::Format("{0} {1}", "Creating download folder at:", $downloadPath))
New-Item -ItemType Directory -Force -Path $downloadPath

$uriList = @($ConfigFile.Settings.PostDistrictTxtFile, $ConfigFile.Settings.GeoLocationZipFile) 

DownloadPostDistrictAndGeoLocationFiles -uriList $uriList -downloadPath $downloadPath

ProcessPostDistrictAndGeoLocationFiles -downloadPath $downloadPath
