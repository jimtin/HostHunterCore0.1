function Get-WMIEventBinder
{
    <#
	.Synopsis
	Gets a list of the WMI Event Binders from target set, then links them to their Filter and Consumers. 

	.Description
	Gets a list of the WMI Event Binders from target set.

	.Example
	Get-WMIEventBinder
	#>

    [CmdletBinding()]
    param
    (

    )

    # Get a list of current Event Binders on target
    $wmibinderslist = Invoke-HostCommand -Command{Get-WMIObject -Namespace root\Subscription -Class __FilterToConsumerBinding}

    # Create a Powershell array with details about the WMI Filters returned
    $wmibinders = @()

    foreach($filter in $wmibinderslist)
    {
        $binderobject = @{
            WMIBinderFilterName = $filter.Filter
            FilterFrameworkArtifact = "NotKnownYet" # todo: update with HostHunterArtifact collection
            WMIBinderConsumerName = $filter.Consumer
            ConsumerFrameworkArtifact = "NotKnownYet" # todo: update with HostHunterArtifact collection
            EndpointName = $filter.PSComputerName
            FrameworkArtifact = "NotKnownYet" # todo: update with HostHunterArtifact collection
        }
        # Add to WMIFilters array
        $wmibinders += $binderobject
    }

    # todo: include SIEM interaction

    # Return object from function
    Write-Output $wmibinders

}