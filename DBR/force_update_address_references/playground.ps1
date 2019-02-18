. .\Functions.ps1

[xml]$ConfigFile = Get-Content "./Settings.xml"

New-Variable -Name "DOWNLOAD_FOLDER" -Value $ConfigFile.Settings.DownloadFolder -Option Constant
$downloadPath = [string]::Format("{0}\{1}", $PSScriptRoot, $DOWNLOAD_FOLDER)
New-Item -ItemType Directory -Force -Path $downloadPath
$uriList = @(
    $ConfigFile.Settings.PostDistrictTxtFile,
    $ConfigFile.Settings.GeoLocationZipFile
    ) 
DownloadPostDistrictAndGeoLocationFiles -uriList $uriList 

#$fileList = Get-ChildItem
# UPS! Is it necessary to process the post district file first ???
# --> Check the update methods in BatchClient.
#
# foreach ($file in $downloadFolderPath )
#   if (.txt)
#   {
#       Do stuff   
#   }
#   elseif (.zip)
#   {
#       Do stuff 
#   }
#   else
#   {
#       Do stuff 
#   }

