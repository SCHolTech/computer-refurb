. $PSScriptRoot\Functions\Set-NextScript.ps1
. $PSScriptRoot\Functions\Test-WindowsIsActivated.ps1
. $PSScriptRoot\Functions\Test-WindowsUpdatesAreInstalled.ps1
. $PSScriptRoot\Functions\Get-Report.ps1
. $PSScriptRoot\Functions\Set-Report.ps1
. $PSScriptRoot\Functions\Write-LocalLog.ps1
. $PSScriptRoot\Functions\Test-Keyboard.ps1
. $PSScriptRoot\Functions\Test-Trackpad.ps1
. $PSScriptRoot\Functions\Test-Mouse.ps1
. $PSScriptRoot\Functions\Test-HotKeys.ps1
. $PSScriptRoot\Functions\Test-Battery.ps1
. $PSScriptRoot\Functions\Test-Speakers.ps1
. $PSScriptRoot\Functions\Test-HDVideoPlayback.ps1
. $PSScriptRoot\Functions\Install-WindowsUpdates.ps1
. $PSScriptRoot\Functions\Set-LanguageOptions.ps1

Set-Location $PSScriptRoot
Write-LocalLog -Message "Begin $($MyInvocation.MyCommand.Name)"
Write-Host "The computer is currently named $env:computername"
$report = Get-Report
Install-WindowsUpdates
Test-WindowsUpdatesAreInstalled
Test-WindowsIsActivated

$report = Set-LanguageOptions -Report $report

#test chassis (lid, hinges, screws, joins)
$report = Test-Keyboard -Report $report
$report = Test-Trackpad -Report $report
$report = Test-Mouse -Report $report
$report = Test-Hotkeys -Report $report
$report = Test-Battery -Report $report
$report = Test-Speakers -Report $report
$report = Test-HDVideoPlayback -Report $report
#test mic
#test camera
#test charger
$report.Computer.Hardware.Charger.TestedOk = (Read-Host -Prompt "Charger tested ok? (y/n)").ToLower() -eq "y"
#test screen

Set-Report -Report $report
Set-NextScript -StepName "SCHolStep2" -ScriptAbsolutePath $PSScriptRoot\setup-stage020.ps1
Write-LocalLog -Message "Completed $($MyInvocation.MyCommand.Name)"
Restart-Computer -Force