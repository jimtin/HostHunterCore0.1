# Test that host command connects to local endpoint
# Confirm that $target and $creds global variables exist
if(-not $target){
    Write-Host -Object "Set target variable first"
}elseif(-not $creds){
    Write-Host -Object "Set credentials under creds variable first"
}else{
    Describe -Tags "RemoteConnections" "Invoke-HostCommand"{
        It "Connects to a local target"{
            Invoke-HostCommand -Command {Get-Process} | Should -Not -Be $null
        }
    }
}

