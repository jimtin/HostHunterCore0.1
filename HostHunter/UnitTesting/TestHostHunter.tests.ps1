# Example test to confirm Pester is working
Describe -Tags "Example" "Get-Process"{
    It "Gets a process"{
        Get-Process -Name lsass | Should -Not -Be $null
    }
}

# Test that host command connects to local endpoint
# Confirm that $target and $creds global variables exist
Test-HostCommand
