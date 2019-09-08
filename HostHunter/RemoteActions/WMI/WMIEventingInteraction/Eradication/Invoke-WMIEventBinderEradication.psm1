function Invoke-WMIEventBinderEradication
{
    <#
	.Synopsis
	Eradicates WMI Event Binders from Target variable. Can specify the name of the filter to eradicate. 

	.Description
	Eradicates WMI Event Binders from Target. Can specify the name of the filter to eradicate. 
	
	.Parameter
	Name - the name of the binder to eradicate, default is all

	.Example
	Invoke-WMIEventBinderEradication -Name <NameOfFilter>
	#>

    [CmdletBinding()]
    param
    (
        $Name
    )

    # Create return object 
    $outcome = @{
        Command = "WMIEventBinderEradication"
        BinderName = ""
        Outcome = ""
    }

    # todo: identify if this is a deliberate HostHunter artifact

    # If name has a value, update string to include this as a filter
    if($Name) {
        $outcome.BinderName = $Name
        # Create Removal String
        $removalstring = "Get-WMIObject -Namespace root\subscription -Class __FilterToConsumerBinding | Where-Object __PATH -Match '$Name' | Remove-WMIObject
                         Write-Output 'EventBinder $Name deleted'"
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
        $outcome.BinderName = "All"
        # Create Removal String
        $removalstring = "Get-WMIObject -Namespace root\subscription -Class __FilterToConsumerBinding | Remove-WMIObject
                Write-Output 'All Event Binders deleted'"
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