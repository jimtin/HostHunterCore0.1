function Out-AccountabilityObject
{
    <# 
    .Synopsis
     Creates an accountability object and sends it to the SIEM
     
     .Description
     Takes the specified command string, then creates the HostHunter Accountability Object. Sends the object to the
     SIEM. Returns the Unique Hash ID
     
     .Parameter
     Command - the command string to be executed
     
     .Example
     Out-AccountabilityObject -Command Get-Process
    
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]$Command
    )
    
    # Create the unique CommandID

    # Create a unique CommandID object so that command can be tracked through the network
    $CommandID = Get-Random
    $CommandID = $CommandID.ToString()
    $hasher = New-Object System.Security.Cryptography.SHA256Managed
    $tohash = [System.Text.Encoding]::UTF8.GetBytes($CommandID)
    $hashByteArray = $hasher.ComputeHash($tohash)
    foreach($byte in $hashByteArray)
    {
        $CommandIDHash += $byte.toString()
    }

    # Get hash of command. 
    $CommandString = $Command.ToString()
    $hasher = New-Object System.Security.Cryptography.SHA256Managed
    $tohash = [System.Text.Encoding]::UTF8.GetBytes($CommandString)
    $hashByteArray = $hasher.ComputeHash($tohash)
    foreach($byte in $hashByteArray)
    {
        $CommandHash += $byte.toString()
    }

    # Create Command Object
    $CommandObject = @{
        "CommandID" = $CommandIDHash
        "Operator" = "JamesHinton"
        "Target" = $Target
        "TimeExecuted" = Get-Date
        "CommandExecuted" = $Command
    }

    # Convert into JSON
    $CommandString = $CommandObject | ConvertTo-Json | Out-String

    # Send to tracking SIEM
    Out-SIEM -StringToSend $CommandString
    
    Write-Output $CommandObject
    
}
