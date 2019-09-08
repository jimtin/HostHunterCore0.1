function Invoke-WMIEventBinder
{
    <#
	.Synopsis
	Third part of WMI Eventing. Binds an Event Filter and Event Consumer together

	.Description
	Binds an Event Filter and Event Consumer together, and records this artifact in the SIEM.

	.Parameter
	FilterObject - the name of the WMI Event actions to be undertaken
	
	.Parameter 
	ConsumerObject - the type of consumer to be created

	.Example
	Invoke-WMIEventBinder -FilterObject $filterobject -ConsumerObject $consumerobject
	#>

    [CmdletBinding()]
    param
    (
        $FilterObject,
        $ConsumerObject
    )

    ###############################################################################################################
    # Logical Accountability
    # Create the command key details
    $command = @{
        Type = "WMIEventBinder"
        WQLQuery = $WQLQuery
    }
    $commandtracking = Out-AccountabilityObject -Command $Command
    $CommandIDHash = $commandtracking.CommandID
    ###############################################################################################################
    
    # Run on remote machine
    $binder = Invoke-Command -ComputerName $target -Credential $creds -ScriptBlock{
        $FilterToConsumerArgs = @{
            Filter = $args[0]
            Consumer = $args[1]
        }
        $binder = Set-WmiInstance -Namespace root/subscription -Class __FilterToConsumerBinding -Arguments $FilterToConsumerArgs
    Write-Output "BinderCreated"
    } -ArgumentList $FilterObject, $ConsumerObject
    
    $output = $binder

    ###############################################################################################################
    # Send output to SIEM
    Out-CommandReturnObject -CommandID $CommandIDHash -InvokeObject $Output
    ###############################################################################################################

    # Return object to Powershell window
    Write-Output $binder
}