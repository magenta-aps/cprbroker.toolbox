. .\Utilities.ps1

[xml]$ConfigFile = Get-Content "./Settings.xml"

###############################################
### FETCHING CPR NUMBERS FROM DPR EMULATION ###
###############################################

$dpr_emu_src = $ConfigFile.Settings.Database.DprEmulation.Source
$dpr_emu_db = $ConfigFile.Settings.Database.DprEmulation.InitialCatalog
$dpr_emu_usr = $ConfigFile.Settings.Database.DprEmulation.UserId
$dpr_emu_pwd = $ConfigFile.Settings.Database.DprEmulation.Password

$connectionString = "Data Source='$dpr_emu_src';" +
            "Initial Catalog='$dpr_emu_db';" +
            "User id='$dpr_emu_usr';" +
            "Password='$dpr_emu_pwd';"

$dpr_emu_query = $("SELECT [PNR] FROM $dpr_emu_db.[dbo].[DTTOTAL] WHERE VEJKOD = 0 AND STATUS = 01")
$dttotal_pnr_array = GetCprNumbersDttotalWithoutVejkod -connection_string $connectionString, -sql_query $dpr_emu_query

########################################################
### FOR EACH CPR NUMBER FETCH MOST RECENT EXTRACT ID ###
########################################################

foreach($cpr_no in $dttotal_pnr_array) {
    echo $cpr_no
    # TODO:
    # Get-Latest-ExtractId-From-CprBroker-Extract()
    # insert row into CprBroker    
}