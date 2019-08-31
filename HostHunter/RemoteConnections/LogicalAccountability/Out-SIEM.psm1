function Out-SIEM{
    <# 
    .Synopsis
     Sends outputs to SIEM
     
     .Description
     Gets the settings for SIEM and sends outputs to it
     
     .Parameter
     StringToSend - The string to be sent
     
     .Example
     Out-SIEM -StringToSend "Hello World"
    
    #>

    param(
        [Parameter(Mandatory=$true)][String]$StringToSend
    )

    # Use Out-UDP command
    Out-UDP -DestinationIP $DestinationIP -DestinationPort $DestinationPort -StringToSend $StringToSend | Out-Null
}