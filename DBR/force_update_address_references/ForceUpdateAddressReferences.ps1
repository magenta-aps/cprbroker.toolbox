. .\Functions.ps1

[xml]$ConfigFile = Get-Content "./Settings.xml"

###########################################
### Configuration of settings variables ###
###########################################

$DprEmuSrc = $ConfigFile.Settings.Database.DprEmulation.Source
$DprEmuDb = $ConfigFile.Settings.Database.DprEmulation.InitialCatalog
$DprEmuUsr = $ConfigFile.Settings.Database.DprEmulation.UserId
$DprEmuPwd = $ConfigFile.Settings.Database.DprEmulation.Password

$DprEmuDbConMap = @{ "DataSource" = $DprEmuSrc; 
                    "InitialCatalog" = $DprEmuDb;
                    "UserId" = $DprEmuUsr;
                    "Password"= $DprEmuPwd }

$CprBrokerSrc = $ConfigFile.Settings.Database.CprBroker.Source
$CprBrokerDb = $ConfigFile.Settings.Database.CprBroker.InitialCatalog
$CprBrokerUsr = $ConfigFile.Settings.Database.CprBroker.UserId
$CprBrokerPwd = $ConfigFile.Settings.Database.CprBroker.Password

$CprBrokerDbConMap = @{ "DataSource" = $CprBrokerSrc; 
                        "InitialCatalog" = $CprBrokerDb;
                        "UserId" = $CprBrokerUsr;
                        "Password"= $CprBrokerPwd }

$downloadFolder = $ConfigFile.Settings.DownloadFolder

$postDistrictData = $ConfigFile.Settings.PostDistrictTxtFile

$GeoLocationData = $ConfigFile.Settings.GeoLocationZipFile

###############################################
### UPDATE DPR EMULATION ADDRESS REFERENCES ###
###############################################

New-Variable -Name "DOWNLOAD_FOLDER" -Value $downloadFolder -Option Constant
$downloadPath = [string]::Format("{0}\{1}", $PSScriptRoot, $DOWNLOAD_FOLDER)
New-Item -ItemType Directory -Force -Path $downloadPath

$uriList = @($postDistrictData, $GeoLocationData) 

DownloadPostDistrictAndGeoLocationFiles -uriList $uriList -downloadPath $downloadPath

ProcessPostDistrictAndGeoLocationFiles -downloadPath $downloadPath

###################################################
### GET ARRAY OF CPR NUMBERS FROM DPR EMULATION ###
###################################################

$DttotalCprNoArray = GetCprNumbersDttotalWithoutVejkod -ConnectionMap $DprEmuDbConMap
Write-Host "[INFO]:"$DttotalCprNoArray.length" persons in DPR Emulation DTTOTAL without address reference."

#########################
### GET ItemKey array ###
#########################

$ItemKeyArray = GetItemKeyArray -ConnectionMap $CprBrokerDbConMap -CprNoArray $DttotalCprNoArray

# Output status to inform if the two collections are equal in size.
if ($DttotalCprNoArray.length -eq $ItemKeyArray.length) 
{
    Write-Host  "[INFO]: 'DttotalCprNoArray' and 'ItemKeyArray' are equal in size which means we found an Extract Id for each cpr number."
} 
else
{
    Write-Host  "[WARNING]: 'DttotalCprNoArray' and 'ItemKeyArray' are NOT equal in size which means we did not find an ExtractId for each cpr number."
}

##################################
### INSERT ROWS INTO QUEUEITEM ###
##################################

$DbrQueueId = $ConfigFile.Settings.QueueId

InsertIntoCprBrokerQueueItem -ConnectionMap $CprBrokerDbConMap -QueueId $DbrQueueId -ItemKeyArray $ItemKeyArray