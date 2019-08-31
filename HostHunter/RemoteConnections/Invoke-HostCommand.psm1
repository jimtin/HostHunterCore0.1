function Invoke-HostCommand{
    <#
	.Synopsis
	Rework of Powershell Invoke Command to include hunt requirements. 

	.Description
	Rework of Powershell Invoke Command. Currently a simple rewrite to enable later functionality to be added. 

	.Parameter
	Target - Specifies the endpoint(s) to be targeted
	
	.Parameter
	Credentials - [System.Management.Automation.CredentialAttribute()][Mandatory] Specifies which credentials are to be used
	
	.Parameter
	Command [Scriptblock][Mandatory] Commands to be passed to target machine

	.Example
	Invoke-HostCommand -ComputerName <computerName> -Credential <Credentials> -Scriptblock {Get-Process}
	#>
    
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)][Scriptblock]$Command
    )
    
    ###############################################################################################################
    # Host Hunter Tracking # 
    
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
    $CommandObject = New-Object -TypeName psobject -Property $initialObject
    $CommandObject = $CommandObject | ConvertTo-Json | Out-String
    
    # Send to tracking SIEM (currently not a thing)
    Out-SIEM -StringToSend $CommandObject
    
    ###############################################################################################################
    
    # Check Target and Creds are set
    if(-not $Target){
       $newtarget = Read-Host -Prompt "Input Target"
       $target = $newtarget.ToString()
    }
    
    if(-not $cred){
        $cred = Get-Credential
    }
    
    # Execute Command
    # TODO: integrate system
    
    if($System){
        
    }else{
        $Output = Invoke-Command -ComputerName $Target -Credential $cred -ScriptBlock $Command
    }
    
    # Write result to SIEM
    foreach($object in $Output)
    {
        # Add unique identifier
        $object | Add-Member -NotePropertyName "CommandID" -NotePropertyValue $CommandIDHash | ConvertTo-Json | Out-String
        Out-SIEM -StringToSend $object | Out-Null
    }
    
    # Now return object as per usual
    Write-Output $Output
    
}