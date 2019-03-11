$dpr_emulering_diversion_host = "<private ip>"
$dpr_emulering_diversion_port =  "<port>"
$target_file = Get-Content "<file_names_are_referenced_without_quotes>"
$dpr_emulering_diversion = "<C:\PATH\TO\DprDiversionCaller.exe>"

# ampersand is used to run the referenced executable, along with the 3 arguments
foreach ($cprnr in $target_file) {
    & $dpr_emulering_diversion $dpr_emulering_diversion_host $dpr_emulering_diversion_port $cprnr
}