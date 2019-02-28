# Created by Heini (2019)
# Returns cpr data in the form CPR Direct proxy sends it

# Consider changing to commandline arguments
$server = "10.0.2.15"
$port = 53687

$pnrFile = Get-Content ""

$inquiryType = "1"
# * DataNotUpdatedAutomatically = 0
# * DataUpdatedAutomaticallyFromCpr = 1
# * DeleteAutomaticDataUpdateFromCpr = 3

$detailType = "1"
# * MasterData = 0, // Only to client
# * ExtendedData = 1 // Put to DPR database

# 10 digit cpr number, aka person registration number

$message = ($inquiryType + $detailType + $cprno)

$requestInfo = [string]::Format("Request attempt to {0}:{1}", $server, $port)
Write-Output $requestInfo

foreach ($cprnr in $target_file)
{
    $socket = new-object System.Net.Sockets.TcpClient($server, $port)
    $data = [System.Text.Encoding]::ASCII.GetBytes($message)
    $stream = $socket.GetStream()
    $stream.Write($data, 0, $data.Length)
    # Read response? See : https://docs.microsoft.com/en-us/dotnet/api/system.net.sockets.networkstream.read?view=netframework-4.7.2
    $stream.Close()
    $socket.Close()
}
