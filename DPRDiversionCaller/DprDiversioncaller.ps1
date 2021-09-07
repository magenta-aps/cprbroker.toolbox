# Created by Heini (2019)
# Returns cpr data in the form CPR Direct proxy sends it

# Consider changing to commandline arguments
$server = "<IP_ADDRESS>"
$port = <PORT_NO>
$cpr_no "CPR_NO"

##### INQUIRY TYPES #####
# * DataNotUpdatedAutomatically = 0
# * DataUpdatedAutomaticallyFromCpr = 1
# * DeleteAutomaticDataUpdateFromCpr = 3
$inquiryType = "1"

##### DETAIL TYPES #####
# * MasterData = 0, // Only to client
# * ExtendedData = 1 // Put to DPR database
$detailType = "1"

$message = ($inquiryType + $detailType + $cpr_no)

$requestInfo = [string]::Format("Request attempt to {0}:{1} with message: {2}", $server, $port, $message)
Write-Output $requestInfo

$socket = new-object System.Net.Sockets.TcpClient($server, $port)
$data = [System.Text.Encoding]::ASCII.GetBytes($message)
$stream = $socket.GetStream()
$stream.Write($data, 0, $data.Length)
# Reading response from stream missing !
# Read response? See : https://docs.microsoft.com/en-us/dotnet/api/system.net.sockets.networkstream.read?view=netframework-4.7.2
$stream.Close()
$socket.Close()
