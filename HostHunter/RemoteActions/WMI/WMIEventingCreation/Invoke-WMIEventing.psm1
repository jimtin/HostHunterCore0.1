function Invoke-WMIEventing
{
    <#
	.Synopsis
	Creates a WMI Event Filter and Binder. Provides some preset values for easy deployment.

	.Description
	Combines the three aspects of WMI Eventing to create powerful WMI Event filters. Provides some pre-set values 
	for ease of use, but can be customised further. 

	.Parameter
	Name - the name of the WMI Event actions to be undertaken
	
	.Parameter
	WQLQuery - the WMI Query being used

	.Example
	Invoke-WMIEventing -Name "notepadstartup"
	
	.Example
	Invoke-WMIEventing -Name "CustomCommand" -Query "SELECT * FROM __InstanceCreationEvent"
	#>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)][String]$Name,
        $WQLQuery
    )

    # If a preset value is used, set the WQL Query
    if($Name -eq "NotepadStartup")
    {
        Write-Host -Object "Prebuilt WMI Eventing NotepadStartup selected" -ForegroundColor Cyan
        $Name = "NotepadDetect"
        $WQLQuery = "SELECT * FROM Win32_ProcessStartTrace WHERE ProcessName='notepad.exe'"
        $Class = 'ActiveScript'
        Write-Host -Object "Start UDPReceiver.exe on Port $port to watch for Notepad.exe startups" -ForegroundColor White
    }
    
    $Outcome = @{
        FilterOutcome = ""
        ConsumerOutcome = ""
        BinderOutcome = ""
        Outcome = $false
    }
    
    # Invoke the setup of the Filter
    Write-Host -Object "Creating WMI Event Filter $Name on $target" -ForegroundColor Cyan
    $filter = Invoke-WMIEventFilter -Name $Name -WQLQuery $WQLQuery
    $Outcome.FilterOutcome = $filter
    
    # Invoke the setup of the Consumer
    Write-Host -Object "Creating WMI Event Consumer $Name Consumer on $target" -ForegroundColor Cyan
    $consumer = Invoke-WMIEventConsumer -Name $Name -Class $Class
    $Outcome.ConsumerOutcome = $consumer
    
    # Invoke the setup of the Binder
    Write-Host -Object "Creating WMI Event Binder for Filter:$filtername and Consumer:$consumername on $target" -ForegroundColor Cyan
    $binder = Invoke-WMIEventBinder -FilterObject $filter -ConsumerObject $consumer
    $Outcome.BinderOutcome = $binder
    $Outcome.Outcome = $true
    
    # Return the output
    Write-Output $output

}