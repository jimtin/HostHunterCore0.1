function Invoke-WMIEventFilter
{
    <#
	.Synopsis
	First part of WMI Event Driven Hunting

	.Description
	Creates a WMI Event filter on the remote endpoint, and records this artifact in the SIEM.

	.Parameter
	Name - the name of the WMI Event actions to be undertaken
	
	.Parameter
	WQLQuery - the WMI Query being used
	
	.Parameter
	Preset - if a preset value is being used

	.Example
	Invoke-WMIEventFilter -Preset "notepadstartup"
	
	.Example
	Invoke-WMIEventFilter -Name "CustomName" -Query "SELECT * FROM __InstanceCreationEvent"
	#>

    [CmdletBinding()]
    param
    (
        $Name,
        [ValidateSet("NotepadStartup")]$Preset,
        $WQLQuery
    )
    
    ###############################################################################################################
    # Logical Accountability
    # Create the command key details
    $command = @{
        Type = "WMIEventFilter"
        WQLQuery = $WQLQuery
    }
    $commandtracking = Out-AccountabilityObject -Command $Command
    $CommandIDHash = $commandtracking.CommandID
    ###############################################################################################################
    
    # Run on remote machine
    $eventfilter = Invoke-Command -ComputerName $target -Credential $creds -ScriptBlock {
        $wmiParams = @{
            Computername = $env:COMPUTERNAME
            ErrorAction = 'Stop'
            NameSpace = 'root\subscription'
        }
        $wmiParams.Class = '__EventFilter'
        $wmiParams.Arguments = @{
            Name = $args[0].ToString()
            EventNamespace = 'root\CIMV2'
            QueryLanguage = 'WQL'
            Query = $args[1]
        }
        $filterResult = Set-WmiInstance @wmiParams
        Write-Output $filterResult
    } -ArgumentList $Name, $WQLQuery

    ###############################################################################################################
    # Send output to SIEM
    Out-CommandReturnObject -CommandID $CommandIDHash -InvokeObject $Output
    ###############################################################################################################
    
    # Return object to Powershell window
    Write-Output $eventfilter
    
}