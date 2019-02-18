. .\Functions.ps1

[xml]$ConfigFile = Get-Content "./Settings.xml"

$uriList = @($ConfigFile.Settings.PostDistrictTxtFile, $ConfigFile.Settings.GeoLocationZipFile) 
DownloadPostDistrictAndGeoLocationFiles -uriList $uriList 

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

