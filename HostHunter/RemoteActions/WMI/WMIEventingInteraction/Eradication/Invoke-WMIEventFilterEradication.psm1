function Invoke-WMIEventFilterEradication
{
    <#
	.Synopsis
	Eradicates WMI Event Filters from Target. Can specify the name of the filter to eradicate. 

	.Description
	Eradicates WMI Event Filters from Target. Can specify the name of the filter to eradicate. 
	
	.Parameter
	Name - the name of the filter to eradicate, default is all

	.Example
	Invoke-WMIEventFilterEradication -Name <NameOfFilter>
	#>

    [CmdletBinding()]
    param
    (
        $Name
    )
    
    # Create return object 
    $outcome = @{
        Command = "WMIEventFilterEradication"
        FilterName = ""
        Outcome = ""
    }
    
    # If name has a value, update string to include this as a filter
    if($Name) {
        $outcome.FilterName = $Name
        # Create Removal String
        $removalstring = "Get-WMIObject -Namespace root\subscription -Class __EventFilter | Where-Object Name -EQ '$Name' | Remove-WMIObject
        Write-Output 'EventFilter $Name deleted'"
        # Create removal Scriptblock
        $removalscriptblock = [ScriptBlock]::Create($removalstring)
        # Delete the WMI Event Filters
        $wmibinderslist = Invoke-HostCommand -Command $removalscriptblock
        # Confirm that the WMI Event Filter has been deleted
        $filters = Get-WMIEventFilter
        if($filters.Name -eq $Name){
            $outcome.Outcome = $false
        }else{
            $outcome.Outcome = $true
        }
    }else{
        $outcome.FilterName = "All"
        # Create Removal String
        $removalstring = "Get-WMIObject -Namespace root\subscription -Class __EventFilter | Remove-WMIObject
        Write-Output 'All Event Filters deleted'"
        # Create removal Scriptblock
        $removalscriptblock = [ScriptBlock]::Create($removalstring)
        # Delete the WMI Event Filters
        $wmibinderslist = Invoke-HostCommand -Command $removalscriptblock
        $outcome.Outcome = $true
    }

    # todo: include SIEM interaction

    # Return object from function
    Write-Output $outcome

}