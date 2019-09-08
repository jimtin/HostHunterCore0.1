function Invoke-WMIEventingEradication
{
    <#
	.Synopsis
	Eradicates a prebuilt WMI Event Filter, Consumer and Binder

	.Description
	Eradicates a prebuilt WMI Event Filter, Consumer and Binder

	.Parameter
	Name - the name of the prebuilt WMI Event

	.Example
	Invoke-WMIEventingEradication -Name "notepadstartup"

	#>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)][String]$Name,
        $WQLQuery
    )

    # If a preset value is used, set the WQL Query
    if($Name -eq "NotepadStartup")
    {
        Write-Host -Object "Prebuilt WMI Eventing NotepadStartup selected" -ForegroundColor Cyan
        $FilterName = "NotepadDetect"
        $ConsumerName = "NotepadDetectConsumer"
        $BinderName = "NotepadDetect"
    }

    $Outcome = @{
        FilterOutcome = ""
        ConsumerOutcome = ""
        BinderOutcome = ""
        Outcome = $false
    }

    # Invoke the setup of the Filter
    Write-Host -Object "Eradicating WMI Event Filter $FilterName on $target" -ForegroundColor Cyan
    $filter = Invoke-WMIEventFilterEradication -Name $FilterName
    $Outcome.FilterOutcome = $filter

    # Invoke the setup of the Consumer
    Write-Host -Object "Eradicating WMI Event Consumer $ConsumerName on $target" -ForegroundColor Cyan
    $consumer = Invoke-WMIEventConsumerEradication -Name $ConsumerName
    $Outcome.ConsumerOutcome = $consumer

    # Invoke the setup of the Binder
    Write-Host -Object "Eradicating WMI Event Binder for Filter:$filtername and Consumer:$consumername on $target" -ForegroundColor Cyan
    $binder = Invoke-WMIEventBinderEradication -Name $BinderName
    $Outcome.BinderOutcome = $binder
    $Outcome.Outcome = $true

    # Return the output
    Write-Output $output

}