. $PSScriptRoot\Functions\Get-Report.ps1
. $PSScriptRoot\Functions\Set-Report.ps1
. $PSScriptRoot\Functions\Write-LocalLog.ps1

Set-Location $PSScriptRoot
Write-LocalLog -Message "Begin $($MyInvocation.MyCommand.Name)"
Write-Host "The computer is currently named $env:computername"
$report = Get-Report

Import-Module PSWindowsUpdate
Add-Type -AssemblyName System.DirectoryServices.AccountManagement
$context = New-Object System.DirectoryServices.AccountManagement.PrincipalContext('machine', $env:COMPUTERNAME)

$report.Computer.Software.Windows.User.Password = Read-Host -Prompt "Enter password for user $($report.User.Name)"
$report.Computer.Software.Windows.User.CredentialsValidated = $context.ValidateCredentials($report.Computer.Software.Windows.User.Name, $report.Computer.Software.Windows.User.Password)
$report.Computer.Software.Windows.Updates.CountRemaining = (Get-WindowsUpdate).Count

$report.Computer.Software.Edge.HistoryCleared = (Read-Host -Prompt "Browser history cleared? (y/n)").ToLower() -eq "y"

Set-Report -Report $report
Write-LocalLog -Message "Completed $($MyInvocation.MyCommand.Name)"
. $PSScriptRoot\setup-stage045.ps1