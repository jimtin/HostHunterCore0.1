function Out-UDP{
    <# 
    .Synopsis
     Sends a specified string to a UDP socket
     
     .Description
     Sends a specified byte array to specified destination and port
     
     .Parameter
     DestinationIP - The destination IP of the byte stream
     
     .Parameter
     DestinationPort - The destination port of the byte stream
     
     .Parameter
     StringToSend - The string to be sent
     
     .Example
     Out-UDP -DestinationIP '127.0.0.1' -DestinationPort 9990 -StringToSend "Hello World"
    
    #>
    
    param(
        [Parameter(Mandatory=$true)]$DestinationIP,
        [Parameter(Mandatory=$true)]$DestinationPort,
        [Parameter(Mandatory=$true)][String]$StringToSend
    )
    
    # Define the IP Object
    $Address = [System.Net.IPAddress]::Parse($DestinationIP)
    
    # Create the IP Endpoint
    $End = New-Object System.Net.IPEndPoint $Address, $DestinationPort
    
    # Create Socket
    $Saddrf = [System.Net.Sockets.AddressFamily]::InterNetwork
    $Stype = [System.Net.Sockets.SocketType]::Dgram
    $Ptype = [System.Net.Sockets.ProtocolType]::UDP
    $Sock = New-Object System.Net.Sockets.Socket $saddrf, $Stype, $Ptype
    $sock.Ttl = 26
    
    # Connect to the socket
    $Sock.Connect($end)
    
    # Create encoded buffer from String
    $Enc = [System.Text.Encoding]::ASCII
    $Buffer = $Enc.GetBytes($StringToSend)
    
    # Send the string to remote port
    $Sent = $Sock.Send($Buffer) | Out-Null
    
    # Close the socket
    $Sock.Close()
}