function Invoke-WMIEventBinder
{
    <#
	.Synopsis
	Third part of WMI Eventing. Binds an Event Filter and Event Consumer together

	.Description
	Binds an Event Filter and Event Consumer together, and records this artifact in the SIEM.

	.Parameter
	FilterName - the name of the WMI Event actions to be undertaken
	
	.Parameter 
	ConsumerName - the type of consumer to be created

	.Example
	Invoke-WMIEventFilter -Name "CustomName" -Query "SELECT * FROM __InstanceCreationEvent"
	#>

    [CmdletBinding()]
    param
    (
        $FilterName,
        $ConsumerName,
        $BinderName
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

    # Set name
    $name = $BinderName + "Binder"
    
    # Run on remote machine
    $binder = Invoke-Command -ComputerName $target -Credential $creds -ScriptBlock{
        $FilterToConsumerArgs = @{
            Filter = $args[0]
            Consumer = $args[1]
        }
        $Binder = Set-WmiInstance -Namespace root/subscription -Class __FilterToConsumerBinding -Arguments $FilterToConsumerArgs -Namespace $args[2]
        Write-Output $Binder
    } -ArgumentList $FilterName, $ConsumerName, $name

    ###############################################################################################################
    # Send output to SIEM
    Out-CommandReturnObject -CommandID $CommandIDHash -InvokeObject $Output
    ###############################################################################################################

    # Return object to Powershell window
    Write-Output $binder
}