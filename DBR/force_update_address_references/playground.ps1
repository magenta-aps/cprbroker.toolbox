. .\Functions.ps1

[xml]$ConfigFile = Get-Content "./Settings.xml"

$downloadFolderPath = ($PSScriptRoot + "\" + $ConfigFile.Settings.DownloadFolderName)
New-Item -ItemType Directory -Force -Path $downloadFolderPath

$uriList = @($ConfigFile.Settings.PostDistrictTxtFile, $ConfigFile.Settings.GeoLocationZipFile) 

$wc = New-Object System.Net.WebClient

foreach ($uri in $uriList)
{
    try {
        Write-Host ("Trying to download file from " + $uri)
        $filename = $uri.substring($uri.lastIndexOf('/') + 1);
        $wc.DownloadFile($uri, ($downloadFolderPath + "\" + $filename))
    }
    catch [Net.WebException] 
    {
        Write-Host $_.Exception.ToString()
        Write-Host "Exiting program..."
        exit
    }
}

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

