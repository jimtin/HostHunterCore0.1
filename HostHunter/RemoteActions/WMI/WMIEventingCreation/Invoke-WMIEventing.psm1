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
        [Parameter]$WQLQuery
    )

    # If a preset value is used, set the WQL Query
    if($Preset -eq "NotepadStartup")
    {
        $Name = "NotepadDetect"
        $WQLQuery = "SELECT * FROM Win32_ProcessStartTrace WHERE ProcessName=*notepad*"
        $Class = 'ActiveScript'
    }
    
    $output = @{
        FilterOutcome = ""
        ConsumerOutcome = ""
        BinderOutcome = ""
        Outcome = $false
    }
    
    # Invoke the setup of the Filter
    Write-Verbose "Invoking WMIEventBinder"
    $filtername = Invoke-WMIEventFilter -Name $Name -WQLQuery $WQLQuery
    $output.FilterOutcome = $filtername
    
    # Invoke the setup of the Consumer
    Write-Verbose "Invoking WMIEventConsumer"
    $consumername = Invoke-WMIEventConsumer -Name $Name -Class $Class
    $output.ConsumerOutcome = $consumername
    
    # Invoke the setup of the Binder
    Write-Verbose "Invoking WMIEventBinder"
    $bindername = Invoke-WMIEventConsumer -Name $Name -FilterName $filtername.Name -ConsumerName $consumername.Name -BinderName $name
    $output.BinderOutcome = $bindername
    
    # Return the output
    Write-Output $output

}