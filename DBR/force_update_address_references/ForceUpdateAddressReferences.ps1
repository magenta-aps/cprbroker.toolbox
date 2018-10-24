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
    Write-Host "'DttotalCprNoArray' and 'ItemKeyArray' are equal in size."
} 
else
{
    Write-Host "'DttotalCprNoArray' and 'ItemKeyArray' are NOT equal in size."
}

##################################
### INSERT ROWS INTO QUEUEITEM ###
##################################

$DbrQueueId = "0D3D91F4-9B5A-4575-BDDA-0F39FE19B933"
$Created_TS = Get-Date -UFormat "%Y-%m-%d %H:%M:%S:000"
$AttemptCount = 0
$SemaphoreId = "Null"

$ItemKeyArray = InsertIntoCprBrokerQueueItem -ConnectionMap $CprBrokerDbConMap -QueueId $DbrQueueId -ItemKeyArray $ItemKeyArray -CreatedTS $Created_TS -AttemptCount $AttemptCount -SemaphoreId $SemaphoreId