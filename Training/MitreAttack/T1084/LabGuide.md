# Lab Guide

## Setup
1. Load HostHunter into Powershell 5: `.startmission.ps1 <path to T1084TrainingSettings.json>` 
    1. *note: do not use Powershell 6 for this lab as WMI is not currently supported*
2. In a separate Powershell prompt, start the UDP Receiver: `Start-Process UdpReceiver.exe <ipaddress> <port>`
    1. *note: IP address and port are optional. Default is 127.0.0.1 and 9991*
3. Confirm connection to UDP receiver: `Out-UDP -DestinationIP <IPAddress> -DestinationPort <port> -StringToSend "Hello World"`
    1. *Hello World should appear in the UDP Receiver*
4. Load the target into Powershell window titled "Mitre T1084 Lab": `$target = <targetip>`
5. Load credentials into Powershell window titled "Mitre T1084 Lab": `$creds = Get-Credential`

    