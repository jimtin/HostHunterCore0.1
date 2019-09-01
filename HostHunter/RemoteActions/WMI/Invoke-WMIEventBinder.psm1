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
        $ConsumerName
    )
    
    # todo: Include logical accountability

    # With scriptblock setup, now run on remote machine
    $binder = Invoke-Command -ScriptBlock{
        $FilterToConsumerArgs = @{
            Filter = $args[0]
            Consumer = $args[1]
        }
        $Binder = Set-WmiInstance -Namespace root/subscription -Class __FilterToConsumerBinding -Arguments $FilterToConsumerArgs
        Write-Output $Binder
    } -ArgumentList $FilterName, $ConsumerName

    Write-Output $binder
}