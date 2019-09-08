#Requires -RunAsAdministrator

param([string]$SettingsFile)

Write-Information -InformationAction Continue -MessageData "HostHunter starting"

# Set current location for all other commands
$Global:Location = Get-Location

# Load Modules
Write-Information -InformationAction Continue -MessageData "Importing powershell modules"
$loc = $Location.tostring() + "\Manifests\modulemanifest.json"
$modules = Get-Content $loc | ConvertFrom-Json
foreach($line in $modules){
    $filelocation = $Location.toString() + $line.RelativeFileLocation
    $ImportString = "Importing: " + $line.Name
    Write-Information -InformationAction Continue -MessageData $ImportString
    Import-Module $filelocation -Force
}

# Load settings
if($SettingsFile)
{
    $settings = Get-Content -Path $SettingsFile | ConvertFrom-Json
    $Global:DestinationIP = $settings.SIEMSettings.DestinationIP
    $Global:DestinationPort = $settings.SIEMSettings.DestinationPort
    $title = $settings.Title
    $Host.ui.RawUI.WindowTitle = $title
    # Clear the screen
    clear
    Write-Information -InformationAction Continue -MessageData "##################################################"
    Write-Information -InformationAction Continue -MessageData $title
    Write-Information -InformationAction Continue -MessageData "##################################################"
}else{
    Write-Information -InformationAction Continue -MessageData "No Settings Data"
}

