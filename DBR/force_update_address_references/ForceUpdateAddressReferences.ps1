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
$DttotalCprNoArrayLen = @($DttotalCprNoArray).length
echo "People in DPR Emulation without address reference: $DttotalCprNoArrayLen"

###################################################
### GET HASHMAP<cpr_no, most_recent_extract_id> ###
###################################################

$CprBrokerSrc = $ConfigFile.Settings.Database.CprBroker.Source
$CprBrokerDb = $ConfigFile.Settings.Database.CprBroker.InitialCatalog
$CprBrokerUsr = $ConfigFile.Settings.Database.CprBroker.UserId
$CprBrokerPwd = $ConfigFile.Settings.Database.CprBroker.Password

$CprBrokerDbConMap = @{ "DataSource" = $CprBrokerSrc; 
            "InitialCatalog" = $CprBrokerDb;
            "UserId" = $CprBrokerUsr;
            "Password"= $CprBrokerPwd }

$CprNoAndExtractIdMap = GetCprNoAndExtractIdMap -ConnectionMap $CprBrokerDbConMap -cpr_no_array $DttotalCprNoArray

#foreach($cpr_no in $DttotalCprNoArray) {

    # TODO:
    # Get-Latest-ExtractId-From-CprBroker-Extract()
    # insert row into CprBroker    
#}