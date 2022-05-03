Write-Host "Loading $($MyInvocation.MyCommand.Name)"
. $PSScriptRoot\Write-LocalLog.ps1
function Set-NextScript {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$StepName,
        [Parameter(Mandatory=$true)]
        [string]$ScriptAbsolutePath
    )

    $scriptToRun = "C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe -NoExit -ExecutionPolicy Bypass -File $ScriptAbsolutePath"

	New-ItemProperty `
    -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce `
    -Name $StepName `
    -Value $scriptToRun `
    -Force

    Write-LocalLog "Set next script. Manual override: $scriptToRun"
}
Write-Host "$($MyInvocation.MyCommand.Name) Loaded."