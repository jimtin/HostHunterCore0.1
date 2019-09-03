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
    
    $commandtracking = Out-AccountabilityObject -Command $Command
    $CommandIDHash = $commandtracking.CommandID
    
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
    Out-CommandReturnObject -CommandID $CommandIDHash -InvokeObject $Output
    
    # Now return object as per usual
    Write-Output $Output
    
}