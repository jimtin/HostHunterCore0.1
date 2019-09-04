function Invoke-WMIEventConsumer
{
    <#
	.Synopsis
	Second part of WMI Event Driven Hunting

	.Description
	Creates a WMI Event consumer on the remote endpoint, and records this artifact in the SIEM.

	.Parameter
	Name - the name of the WMI Event actions to be undertaken
	
	.Parameter 
	Class - the type of consumer to be created

	.Example
	Invoke-WMIEventConsumer -Preset "notepadstartup"
	
	.Example
	Invoke-WMIEventFilter -Name "CustomName" -Query "SELECT * FROM __InstanceCreationEvent"
	#>

    [CmdletBinding()]
    param
    (
        $Name,
        [ValidateSet('ActiveScript', 'Logfile', 'CommandLineTemplate')]$Class

    )
    
    ###############################################################################################################
    # Logical Accountability
    # Create the command key details
    $command = @{
        Type = "WMIEventConsumer"
        WQLQuery = $WQLQuery
    }
    $commandtracking = Out-AccountabilityObject -Command $Command
    $CommandIDHash = $commandtracking.CommandID
    ###############################################################################################################
    
    # Set name for the consumer
    $name = $name + "Consumer"

    # Run on remote machine
    $consumer = Invoke-Command -ScriptBlock {
        $ipaddress = $args[1]
        $port = $args[2]
        $commandtemplate = "powershell.exe (New-Object System.Net.Sockets.UdpClient).Send([Text.Encoding]::ASCII.GetBytes('NotepadStarted'),[Text.Encoding]::ASCII.GetBytes('NotepadStarted').Length,(New-Object System.Net.IPEndPoint([System.Net.IPAddress]::Parse('$ipaddress'), $port)))"

        $CommandLineConsumerArgs = @{
            Name = $args[0]
            CommandLineTemplate = $commandtemplate
        }
        $Consumer = Set-WmiInstance -Namespace root/subscription -Class CommandLineEventConsumer -Arguments $CommandLineConsumerArgs
        Write-Output $Consumer
    } -ArgumentList $Name, $DestinationIP, $DestinationPort

    ###############################################################################################################
    # Send output to SIEM
    Out-CommandReturnObject -CommandID $CommandIDHash -InvokeObject $Output
    ###############################################################################################################

    # Return output to Powershell window
    Write-Output $consumer
}