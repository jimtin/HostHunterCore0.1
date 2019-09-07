function Invoke-WMIEventConsumerSubversion
{
    <#
	.Synopsis
	Subverts a specified WMI Event Consumer on Target 

	.Description
	Subverts a WMI Event Consumer on Target 
	
	.Parameter
	Name - the name of the Consumer to subvert
	
	.Parameter
	Consumer - the params of the consumer to be subverted

	.Example
	Invoke-WMIEventConsumerSubversion -Name <NameOfFilter> -Consumer <New Event Consumer>
	#>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]$Name,
        [Parameter(Mandatory=$true)]$Consumer
    )

    # Create return object 
    $outcome = @{
        Command = "WMIEventConsumerSubversion"
        ConsumerName = $Name
        Consumer = $Consumer
        Outcome = ""
    }

    # First confirm the consumer name exists on $target
    $filters = Get-WMIEventConsumer
    if($filters.Name -eq $Name){
        # Notify operator that consumer exists
        Write-Information -InformationAction Continue -MessageData "Event Consumer found, continuing"
        # Second, remove original consumer
        $filtereradication = Invoke-WMIEventConsumerEradication -Name $Name
        if($filtereradication.Outcome -eq $true){
            Write-Information -InformationAction Continue -MessageData "Original Event Consumer deleted, continuing"
            # Third, put in a new Event Binder with the same name but different WQL Query
            $subvertedfilter = Invoke-WMIEventConsumer -Name $name -Class $Consumer
            $outcome.Outcome = $true
        }else{
            Write-Information -InformationAction Continue -MessageData "Original Event Consumer failed to delete. Execution finished"
            $outcome.Outcome = "EventConsumerDeletionFailed"
        }
    }else{
        # End execution
        Write-Information -InformationAction Continue -MessageData "Event Consumer not Found, execution finished"
        $outcome.Outcome = "EventConsumerNotFound"
    }

    # todo: include SIEM interaction

    # Return object from function
    Write-Output $outcome

}