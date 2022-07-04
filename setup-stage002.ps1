. $PSScriptRoot\Functions\Copy-ToLocal.ps1
. $PSScriptRoot\Functions\Write-LocalLog.ps1

Write-LocalLog -Message "Begin $($MyInvocation.MyCommand.Name)"
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq $false){
    throw "Please relaunch the commandprompt using the ""Run as administrator"" option"
}
Set-Location $PSScriptRoot
Write-Host "The computer is currently named $env:computername"

$runFromLocal = $false #(Read-Host -Prompt "Run Setup Locally? (y/n)").ToLower() -eq "y"

if($runFromLocal -eq $true) {
    $newRoot = Copy-ToLocal
    . ([System.IO.Path]::Combine($newRoot, "setup-stage005.ps1"))
} else {
    . $PSScriptRoot\setup-stage005.ps1
}

Write-LocalLog -Message "Completed $($MyInvocation.MyCommand.Name)"