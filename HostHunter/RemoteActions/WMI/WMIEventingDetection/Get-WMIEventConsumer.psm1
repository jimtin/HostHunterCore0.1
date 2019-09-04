function Get-WMIEventConsumer
{
    <#
	.Synopsis
	Gets a list of the WMI Event Consumers from target set. 

	.Description
	Gets a list of the WMI Event Consumers from target set.

	.Example
	Get-WMIEventConsumer
	#>

    [CmdletBinding()]
    param
    (

    )

    # Get a list of current Event Consumers on target
    $wmiconsumerslist = Invoke-HostCommand -Command{Get-WMIObject -Namespace root\Subscription -Class __EventConsumer}

    # Create a Powershell array with details about the WMI Filters returned
    $wmiconsumers = @()

    foreach($filter in $wmiconsumerslist)
    {
        $consumerobject = @{
            WMIConsumerName = $filter.Name
            EndpointName = $filter.PSComputerName
            FrameworkArtifact = "NotKnownYet" # todo: update with HostHunterArtifact collection
            WMIConsumerClass = $filter.__CLASS
        }
        # Add to WMIFilters array
        $wmiconsumers += $consumerobject
    }

    # todo: include SIEM interaction

    # Return object from function
    Write-Output $wmiconsumers

}