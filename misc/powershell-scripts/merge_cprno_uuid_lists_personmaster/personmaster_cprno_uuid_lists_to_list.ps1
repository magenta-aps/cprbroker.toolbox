##############################################################
### REMEMBER TO REMOVE HEADERS IN DATABASE EXTRACT FILES ! ###
##############################################################

$new_cprno_uuid = "C:\cprbroker.toolbox\misc\powershell-scripts\merge_cprno_uuid_lists_personmaster\ny-cprbroker-cprno-uuid-comma.csv"
$new_cprno_uuid_hash_table = @{}
foreach($line in [System.IO.File]::ReadLines($new_cprno_uuid)) 
{
    $line_arr = $line.Split(",") # Set delimeter!
    $cprNo = $line_arr[0]
    $uuid = $line_arr[1]
    if ($new_cprno_uuid_hash_table.Contains($cprNo))
    {
        # Do nothing.
    }
    else 
    {
        $new_cprno_uuid_hash_table.Add($cprNo, $uuid)
    }
}

$old_cprno_uuid = "C:\cprbroker.toolbox\misc\powershell-scripts\merge_cprno_uuid_lists_personmaster\old-cprbroker-cprno-uuid-semicolon.csv"
$old_cprno_uuid_hash_table = @{}
foreach($line in [System.IO.File]::ReadLines($old_cprno_uuid)) 
{
    $line_arr = $line.Split(";") # Set delimeter!
    $cprNo = $line_arr[0]
    $uuid = $line_arr[1]
    if ($new_cprno_uuid_hash_table.Contains($cprNo))
    {
        # Do nothing.
    }
    else 
    {
        $old_cprno_uuid_hash_table.Add($cprNo, $uuid)
    }
}

Write-Host "HASH TABLE 1:" $new_cprno_uuid_hash_table.Count
Write-Host "HASH TABLE 2:" $old_cprno_uuid_hash_table.Count

$merged_cprno_uuid_hash_table = @{}

# Adding first hash table.
foreach($cprNo in $new_cprno_uuid_hash_table.keys)
{
    if ($merged_cprno_uuid_hash_table.Contains($cprNo))
    {
        # Do nothing.
    }
    else 
    {
        $merged_cprno_uuid_hash_table.Add($cprNo, $new_cprno_uuid_hash_table.$cprNo)
    }
   
}


# Adding second hash table.
foreach($cprNo in $old_cprno_uuid_hash_table.keys)
{
    if ($merged_cprno_uuid_hash_table.Contains($cprNo))
    {
        # Do nothing.
    }
    else 
    {
        $merged_cprno_uuid_hash_table.Add($cprNo, $old_cprno_uuid_hash_table.$cprNo)
    } 
}
Write-Host "MERGED HASH TABLES:" $merged_cprno_uuid_hash_table.Count

# Writing merged hash table to file.
foreach($cprNo in $merged_cprno_uuid_hash_table.keys)
{
    $k = $cprNo
    $v = $merged_cprno_uuid_hash_table.$cprNo
    try 
    {
        $line_increment = [string]::Format("{0},{1}", $k, $v)
        Add-Content -Path "C:\cprbroker.toolbox\misc\powershell-scripts\merge_cprno_uuid_lists_personmaster\merged_old_and_new_cprbroker_cprno_uuid.csv" -Value $line_increment
    }
    catch 
    {
        $ErrorMessage = $_.Exception.Message
        $output = [string]::Format("FAILED ATTEMPT: {0},{1}", $k, $v)
        Write-Host $output
        Write-Host $ErrorMessage
    }
}

Write-Host "The number of lines in file should match length of merged_cprno_uuid_hash_table."


