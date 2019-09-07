function Invoke-WMIEventConsumerEradication
{
    <#
	.Synopsis
	Eradicates WMI Event Consumers from Target variable. Can specify the name of the filter to eradicate. 

	.Description
	Eradicates WMI Event Consumers from Target. Can specify the name of the filter to eradicate. 
	
	.Parameter
	Name - the name of the Consumer to eradicate, default is all

	.Example
	Invoke-WMIEventConsumerEradication -Name <NameOfFilter>
	#>

    [CmdletBinding()]
    param
    (
        $Name
    )

    # Create return object 
    $outcome = @{
        Command = "WMIEventConsumerEradication"
        ConsumerName = ""
        Outcome = ""
    }
    
    # todo: identify if this is a deliberate HostHunter artifact

    # If name has a value, update string to include this as a filter
    if($Name) {
        $outcome.ConsumerName = $Name
        # Create Removal String
        $removalstring = "Get-WMIObject -Namespace root\subscription -Class __EventConsumer | Where-Object Name -EQ '$Name' | Remove-WMIObject"
        # Create removal Scriptblock
        $removalscriptblock = [ScriptBlock]::Create($removalstring)
        # Delete the WMI Event Filters
        $wmiconsumerslist = Invoke-HostCommand -Command $removalscriptblock
        # Confirm that the WMI Event Filter has been deleted
        $filters = Get-WMIEventFilter
        if($filters.Name -eq $Name){
            $outcome.Outcome = $false
        }else{
            $outcome.Outcome = $true
        }
    }else{
        $outcome.ConsumerName = "All"
        # Create Removal String
        $removalstring = "Get-WMIObject -Namespace root\subscription -Class __EventConsumer | Remove-WMIObject"
        # Create removal Scriptblock
        $removalscriptblock = [ScriptBlock]::Create($removalstring)
        # Delete the WMI Event Filters
        $wmiconsumerslist = Invoke-HostCommand -Command $removalscriptblock
        $outcome.Outcome = $true
    }

    # todo: include SIEM interaction

    # Return object from function
    Write-Output $outcome

}