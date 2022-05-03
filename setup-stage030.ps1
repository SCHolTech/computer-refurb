. $PSScriptRoot\Functions\Get-Report.ps1
. $PSScriptRoot\Functions\Set-Report.ps1
. $PSScriptRoot\Functions\Write-LocalLog.ps1


Set-Location $PSScriptRoot
Write-LocalLog -Message "Begin $($MyInvocation.MyCommand.Name)"
Write-Host "The computer is currently named $env:computername"
$report = Get-Report

$keyboardLanguages = Get-WinUserLanguageList
$report.Computer.Hardware.Keyboard.Languages = @()
$keyboardLanguages | ForEach-Object { 
    $report.Computer.Hardware.Keyboard.Languages += $_.LocalizedName
}
if($keyboardLanguages.Count -gt 1) {
    Read-Host -Prompt "Please install the language packs for your additional keyboard languages and hit enter"
}

Start-Sleep -Seconds 10
Write-Host "Opening Google.."
Write-Host "Please take the following actions:"
Write-Host "  - Dismiss the setup banner in Edge"
Write-Host "  - Add Google to the favourites bar"
Write-Host "  - Set favourites bar to show always"
Write-Host "  - Set startup to always show Google tab"
Write-Host ""
Start-Process microsoft-edge:https://www.google.co.uk
$report.Computer.Software.Edge.SetupBannerDismissed = (Read-Host -Prompt "Has the edge setup banner been dismissed? (y/n)").ToLower() -eq "y"
$report.Computer.Software.Edge.GoogleAsHomepage = (Read-Host -Prompt "Is Google set as the homepage? (y/n)").ToLower() -eq "y"
$report.Computer.Software.Edge.AddGoogleToFavourites = (Read-Host -Prompt "Is Google added to the favourites? (y/n)").ToLower() -eq "y"
$report.Computer.Software.Edge.EnableFavouritesBar = (Read-Host -Prompt "Is the favourites bar enabled? (y/n)").ToLower() -eq "y"

Write-Host "Opening Zoom Test.."
Write-Host "Please take the following actions:"
Write-Host "  - Start a test meeting"
Write-Host "  - Ensure speakers are satisfactory"
Write-Host "  - Ensure mic is satisfactory"
Write-Host "  - Ensure camera is satisfactory"
Write-Host ""
Start-Process microsoft-edge:https://zoom.us/test

$report.Computer.Software.Zoom.TestedOK = (Read-Host -Prompt "Zoom call test successful? (y/n)").ToLower() -eq "y"

if($report.Computer.Software.Zoom.TestedOK -eq $false){
    $report.Computer.Software.Zoom.Notes =  Read-Host -Prompt "Please add any zoom test notes"
    $report.Computer.Hardware.Camera.Present = (Read-Host -Prompt "Does the laptop have a camera? (y/n)").ToLower() -eq "y"
    $report.Computer.Hardware.Microphone.Present = (Read-Host -Prompt "Does the laptop have a microphone? (y/n)").ToLower() -eq "y"
} else {
    $report.Computer.Hardware.Microphone.Present = $true
    $report.Computer.Hardware.Camera.Present = $true
}

if($report.Computer.Hardware.Camera.Present){
    $report.Computer.Hardware.Camera.Quality = Read-Host -Prompt "Camera Quality"
}

if($report.Computer.Hardware.Microphone.Present){
    $report.Computer.Hardware.Microphone.Quality = Read-Host -Prompt "Mic Quality"
}

$report.Computer.Software.Windows.Desktop.FolderOverWorldIcon = (Read-Host -Prompt "Folder over world icon? (y/n)").ToLower() -eq "y"

$report.Computer.OutOfDateStickersRemoved = (Read-Host -Prompt "Out of date stickers removed? (y/n)").ToLower() -eq "y"

$report.Computer.SCHolLabelPresent = (Read-Host -Prompt "SCHol label present on laptop and charger? (y/n)").ToLower() -eq "y"

Set-Report -Report $report
Write-LocalLog -Message "Completed $($MyInvocation.MyCommand.Name)"
. $PSScriptRoot\setup-stage040.ps1
