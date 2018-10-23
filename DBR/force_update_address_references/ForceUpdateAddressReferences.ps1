. .\Utilities.ps1

###############################################
### FETCHING CPR NUMBERS FROM DPR EMULATION ###
###############################################

$dpr_emu_src = ""
$dpr_emu_db = ""
$dpr_emu_usr = ""
$dpr_emu_pwd = ""
$dpr_emu_cmd = $("SELECT [PNR] FROM $dpr_emu_db.[dbo].[DTTOTAL] WHERE VEJKOD = 0 AND STATUS = 01")

$connectionString = "Data Source='$dpr_emu_src';" +
            "Initial Catalog='$dpr_emu_db';" +
            "User id='$dpr_emu_usr';" +
            "Password='$dpr_emu_pwd';"

$result_dttotal = ProcessSelectQuery -connection_string $connectionString, -sql_query $dpr_emu_cmd

$pnr_array = @()

foreach($pnr in $result_dttotal)
{
    # TODO:
    # If the line is 9 digits we have identified a PNR
    # that begins with zero; except that the zero has been removed
    # due to a person number being of type int the DPR data model.
    # If the line is 10 digits we just add it to the array.
    
    $pnr_array += ,$pnr   
}

#################################################
### FOR EACH PNR FETCH MOST RECENT EXTRACT ID ###
#################################################

foreach($pnr in $pnr_array)
{
    # TODO:
    # Get-Latest-ExtractId-From-CprBroker-Extract()
    # insert row into CprBroker   
    echo $pnr
}