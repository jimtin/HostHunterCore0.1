function Invoke-WMIEventFilterSubversion
{
    <#
	.Synopsis
	Subverts a specified WMI Event Filter on Target 

	.Description
	Subverts a WMI Event Filter on Target 
	
	.Parameter
	Name - the name of the filter to subvert
	
	.Parameter
	NewWQL - the new WQL filter to put in place

	.Example
	Invoke-WMIEventFilterSubversion -Name <NameOfFilter> -NewWQL <New WQL Query>
	#>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]$Name,
        [Parameter(Mandatory=$true)]$NewWQL
    )

    # Create return object 
    $outcome = @{
        Command = "WMIEventFilterSubversion"
        FilterName = $Name
        NewWQL = $NewWQL
        Outcome = ""
    }
    
    # First confirm the filter name exists on $target
    $filters = Get-WMIEventFilter
    if($filters.Name -eq $Name){
        # Notify operator that filter exists
        Write-Information -InformationAction Continue -MessageData "Event Filter found, continuing"
        # Second, remove original filter
        $filtereradication = Invoke-WMIEventFilterEradication -Name $Name
        if($filtereradication.Outcome -eq $true){
            Write-Information -InformationAction Continue -MessageData "Original Event Filter deleted, continuing"
            # Third, put in a new Event Filter with the same name but different WQL Query
            $subvertedfilter = Invoke-WMIEventFilter -Name $name -WQLQuery $NewWQL
            $outcome.Outcome = $true
        }else{
            Write-Information -InformationAction Continue -MessageData "Original Event Filter failed to delete. Execution finished"
            $outcome.Outcome = "EventFilterDeletionFailed"
        }
    }else{
        # End execution
        Write-Information -InformationAction Continue -MessageData "Event Filter not Found, execution finished"
        $outcome.Outcome = "EventFilterNotFound"
    }
    
    # todo: include SIEM interaction

    # Return object from function
    Write-Output $outcome

}