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

## Lab Walkthrough
### Demonstrate overall functionality
1. Run the command `Invoke-WMIEventing -Name NotepadStartup`
    1. A series of text lines will be written to command prompt, starting with ```Prebuilt WMI Eventing NotepadStartup selected```
2. Now, start notepad.exe from command prompt `notepad.exe`
    1. The UDPReceiver.exe will pop a line ```NotepadStarted```
3. To prove functionality, start notepad.exe from UI
4. Open another executable - nothing happens!
#### Outcome 
We can observe that something is watching process starts. When certain criteria are met, UDP communications are sent

### Demonstrate removal of functionality
1. Run the command `Invoke-WMIEventingEradication -Name NotepadStartup`
    1. A series of text lines will be written to command prompt, starting with ```Prebuilt WMI Eventing NotepadStartup selected```
2. Now, start notepad.exe from command prompt `notepad.exe`
3. Now, start notepad from UI
4. Now, open another executable 
5. In all cases, nothing happens
#### Outcome
We can observe that the process watching functionality has been removed

### Deconstruct functionality
1. Observe the WMI Event Filter code
    1. This sets the Filter to be alerted upon. In this case an *extrinsic* class has been used.
    2. Observe the Windows Query Language (WQL) Query. `SELECT * FROM Win32_ProcessStartTrace WHERE ProcessName='notepad.exe'`
    3. Understand that this sets the *filter for a firing event*
2. Observe the WMI Event Consumer code
    1. This sets the Outcome which will fire when an event is received
    2. Observe that the class is set to *ActiveScriptEventConsumer*
    3. This is one of five types of event consumers
    4. Observe the script: `powershell.exe (New-Object System.Net.Sockets.UdpClient).Send([Text.Encoding]::ASCII.GetBytes('NotepadStarted'),[Text.Encoding]::ASCII.GetBytes('NotepadStarted').Length,(New-Object System.Net.IPEndPoint([System.Net.IPAddress]::Parse('127.0.0.1'), $port)))`
    5. Note that while this script is relatively static, it can be easily updated
    6. Understand that powershell.exe will start with local system privileges
3. Observe the WMI Event Binder code
    1. The binder links the **Filter** and **Consumer** together
    2. Observe the code - the binder is passed a $filter and $consumer object
    3. The binder itself is NOT named

### Consider some interesting options
1. What if you wanted to understand more about what the adversary was doing?
2. What if you wanted to subvert the filter or consumer?
3. What if you wanted to neutralise the impact of the WMI filter without giving away that you'd discovered it?

All this and more is possible.
