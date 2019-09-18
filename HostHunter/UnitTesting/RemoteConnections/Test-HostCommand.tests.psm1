function Test-HostCommand
{
    <#
	.Synopsis
	Tests the HostCommand module

	.Description
	Tests the HostCommand module

	.Example
	Test-HostCommand
	#>

    # Test that host command connects to local endpoint
    # Confirm that $target and $creds global variables exist
    if (-not $target -and -not $creds)
    {
        Write-Host -ForegroundColor White -Object "Setting target to localhost"
        $Global:Target = "127.0.0.1"
        Write-Host -ForegroundColor White -Object "Credentials not yet set, enter now"
        $Global:creds = Get-Credential
    }
    elseif(-not $creds)
    {
        Write-Host -ForegroundColor White -Object "Credentials not yet set, enter now"
        $Global:creds = Get-Credential
    }
    elseif (-not $target)
    {
        Write-Host -ForegroundColor White -Object "Setting target to localhost"
        $Global:Target = "127.0.0.1"
    }
    Describe -Tags "RemoteConnections" "Invoke-HostCommand"{
        It "Connects to a local target"{
            Invoke-HostCommand -Command { Get-Process } | Should -Not -Be $null
        }
    }
}