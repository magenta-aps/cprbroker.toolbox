. .\Utilities.ps1

[xml]$ConfigFile = Get-Content "./Settings.xml"

###################################################
### GET ARRAY OF CPR NUMBERS FROM DPR EMULATION ###
###################################################

$DprEmuSrc = $ConfigFile.Settings.Database.DprEmulation.Source
$DprEmuDb = $ConfigFile.Settings.Database.DprEmulation.InitialCatalog
$DprEmuUsr = $ConfigFile.Settings.Database.DprEmulation.UserId
$DprEmuPwd = $ConfigFile.Settings.Database.DprEmulation.Password

$DprEmuDbConMap = @{ "DataSource" = $DprEmuSrc; 
                    "InitialCatalog" = $DprEmuDb;
                    "UserId" = $DprEmuUsr;
                    "Password"= $DprEmuPwd }

$DttotalCprNoArray = GetCprNumbersDttotalWithoutVejkod -ConnectionMap $DprEmuDbConMap
Write-Host "[INFO]:"$DttotalCprNoArray.length"persons in DPR Emulation DTTOTAL without address reference."

#########################
### GET ItemKey array ###
#########################

$CprBrokerSrc = $ConfigFile.Settings.Database.CprBroker.Source
$CprBrokerDb = $ConfigFile.Settings.Database.CprBroker.InitialCatalog
$CprBrokerUsr = $ConfigFile.Settings.Database.CprBroker.UserId
$CprBrokerPwd = $ConfigFile.Settings.Database.CprBroker.Password

$CprBrokerDbConMap = @{ "DataSource" = $CprBrokerSrc; 
                        "InitialCatalog" = $CprBrokerDb;
                        "UserId" = $CprBrokerUsr;
                        "Password"= $CprBrokerPwd }

$ItemKeyArray = GetItemKeyArray -ConnectionMap $CprBrokerDbConMap -CprNoArray $DttotalCprNoArray

# Output status to inform if the two collections are equal in size..
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