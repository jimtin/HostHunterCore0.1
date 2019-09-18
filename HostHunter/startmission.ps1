#Requires -RunAsAdministrator

param([string]$SettingsFile,
[Switch]$Test)

clear 

Write-Host -ForegroundColor Blue -Object "###########################################################################"
Write-Host -ForegroundColor Cyan -Object "#########################   HostHunter Starting   #########################"
Write-Host -ForegroundColor Blue -Object "###########################################################################"

# Set current location for all other commands
$Global:Location = Get-Location

# Load Modules
Write-Information -InformationAction Continue -MessageData "Importing powershell modules"
$loc = $Location.tostring() + "\Manifests\modulemanifest.json"
$modules = Get-Content $loc | ConvertFrom-Json
foreach($line in $modules){
    $filelocation = $Location.toString() + $line.RelativeFileLocation
    if($line.Purpose -ne "UnitTest"){
        $ImportString = "Importing: " + $line.Name
        Write-Information -InformationAction Continue -MessageData $ImportString
        Import-Module $filelocation -Force
    }
}

# Load settings
if($SettingsFile)
{
    $settings = Get-Content -Path $SettingsFile | ConvertFrom-Json
    $Global:DestinationIP = $settings.SIEMSettings.DestinationIP
    $Global:DestinationPort = $settings.SIEMSettings.DestinationPort
    $title = $settings.Title
    $Host.ui.RawUI.WindowTitle = $title
    Write-Information -InformationAction Continue -MessageData "##################################################"
    Write-Information -InformationAction Continue -MessageData $title
    Write-Information -InformationAction Continue -MessageData "##################################################"
}elseif($Test){
    Write-Host -ForegroundColor Blue -Object "###########################################################################"
    Write-Host -ForegroundColor Cyan -Object "####################  HostHunter Testing using Pester  ####################"
    Write-Host -ForegroundColor Blue -Object "###########################################################################"
    # Check to make sure Pester is installed
    If(Get-Module -ListAvailable -Name Pester) {
        Write-Host -ForegroundColor Cyan -Object "Pester Testing Framework available"
        $pester = $true
        Write-Host -ForegroundColor Cyan -Object "Loading Test Modules"
        foreach($line in $modules){
            $filelocation = $Location.toString() + $line.RelativeFileLocation
            if($line.Purpose -eq "UnitTest"){
                $ImportString = "Importing: " + $line.Name
                Write-Information -InformationAction Continue -MessageData $ImportString
                Import-Module $filelocation -Force
            }
        }
    }
    else
    {
        Write-Host -Object "Pester not available"
    }
    $Global:DestinationIP = "127.0.0.1"
    $Global:DestinationPort = "9991"
    $title = "HostHunter Unit Testing Framework"
    $Host.ui.RawUI.WindowTitle = $title
    .\UnitTesting\TestHostHunter.tests.ps1
}else{
    Write-Host -ForegroundColor Red -Object "No mission information loaded"
}

Write-Host -ForegroundColor Blue -Object "###########################################################################"
