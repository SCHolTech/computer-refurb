. $PSScriptRoot\Functions\Install-PSModule.ps1
. $PSScriptRoot\Functions\Rename-SCHolTechComputer.ps1
. $PSScriptRoot\Functions\Set-NextScript.ps1
. $PSScriptRoot\Functions\Install-WindowsUpdates.ps1
. $PSScriptRoot\Functions\Write-LocalLog.ps1

Write-LocalLog -Message "Begin $($MyInvocation.MyCommand.Name)"
Set-Location $PSScriptRoot
Write-Host "The computer is currently named $env:computername"

Rename-SCHolTechComputer
Get-PackageProvider -Name Nuget -ForceBootstrap
Install-PSModule -ModuleName "PSWindowsUpdate"
Set-NextScript -StepName "SCHolStep2" -ScriptAbsolutePath $PSScriptRoot\setup-stage010.ps1
Install-WindowsUpdates
Write-LocalLog -Message "Completed $($MyInvocation.MyCommand.Name)"
Restart-Computer -Force