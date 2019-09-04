function Get-WMIEventFilter
{
    <#
	.Synopsis
	Gets a list of the WMI Event Filters from target set. 

	.Description
	Gets a list of the WMI Event Filters from target set.

	.Example
	Get-WMIEventFilter
	#>

    [CmdletBinding()]
    param
    (
        
    )
    
    # Get a list of current Event Filters on target
    $wmifilterslist = Invoke-HostCommand -Command{Get-WMIObject -Namespace root\Subscription -Class __EventFilter}
    
    # Create a Powershell array with details about the WMI Filters returned
    $wmifilters = @()
    
    foreach($filter in $wmifilterslist)
    {
        $filterobject = @{
            WMIFilterName = $filter.Name
            EndpointName = $filter.PSComputerName
            FrameworkArtifact = "NotKnownYet" # todo: update with HostHunterArtifact collection
        }
        # Add to WMIFilters array
        $wmifilters += $filterobject
    }
    
    # todo: include SIEM interaction
    
    # Return object from function
    Write-Output $wmifilters

}