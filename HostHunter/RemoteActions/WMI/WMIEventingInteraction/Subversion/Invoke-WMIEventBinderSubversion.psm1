function Invoke-WMIEventBinderSubversion
{
    <#
	.Synopsis
	Subverts a specified WMI Event Binder on Target 

	.Description
	Subverts a WMI Event Binder on Target 
	
	.Parameter
	Name - the name of the Binder to subvert
	
	.Parameter
	NewConsumer - Name of the new consumer to place in the Binder
	
	.Parameter
	NewFilter - Name of the new filter to place in the Binder

	.Example
	Invoke-WMIEventBinderSubversion -Name <NameOfFilter> -Consumer <ConsumerName> -NewConsumer <NewConsumerName>
	#>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]$Name,
        $NewConsumer,
        $NewFilter
    )

    # Create return object 
    $outcome = @{
        Command = "WMIEventBinderSubversion"
        BinderName = $Name
        SubversionType = ""
        Outcome = ""
    }
    
    # First, figure out the subversion type and update outcome
    if($NewConsumer -and $NewFilter)
    {
        $outcome.SubversionType = "ReplaceFilterandConsumer"
        $outcome.ReplacementFilter = $NewFilter
        $outcome.ReplacementConsumer = $NewConsumer
    }
    elseif ($NewConsumer -and -not $NewFilter)
    {
        $outcome.SubversionType = "ReplaceConsumer"
        $outcome.ReplacementConsumer = $NewConsumer
    }
    elseif ($NewFilter -and -not $NewConsumer)
    {
        $outcome.SubversionType = "ReplaceFilter"
        $outcome.ReplacementFilter = $NewFilter
    }else{
        $outcome.SubversionType = "DoesntExist"
    }

    # todo: put in an error handling thing here
    
    # Second, confirm the binder name exists on $target
    $filters = Get-WMIEventBinder
    if($filters.Name -eq $Name){
        # Notify operator that binder exists
        Write-Information -InformationAction Continue -MessageData "Event Binder found, continuing"
        # Second, remove original binder
        $filtereradication = Invoke-WMIEventBinderEradication -Name $Name
        if($filtereradication.Outcome -eq $true){
            Write-Information -InformationAction Continue -MessageData "Original Event Binder deleted, continuing"
            # Third, put in a new Event Binder with the same name but different parameters based upon the ask
            # todo: Complete this
            if($outcome.SubversionType -eq "ReplaceFilterandConsumer")
            {
                # do something
            }
            elseif ($outcome.SubversionType -eq "ReplaceConsumer")
            {
                # do something else
            }
            elseif ($outcome.SubversionType -eq "ReplaceFilter")
            {
                # do something else
            }
            
        }else{
            Write-Information -InformationAction Continue -MessageData "Original Event Consumer failed to delete. Execution finished"
            $outcome.Outcome = "EventConsumerDeletionFailed"
        }
    }else{
        # End execution
        Write-Information -InformationAction Continue -MessageData "Event Binder not Found, execution finished"
        $outcome.Outcome = "EventConsumerNotFound"
    }

    # todo: include SIEM interaction

    # Return object from function
    Write-Output $outcome

}