$pester = Get-Module Pester -ListAvailable

$installed = $false

$pester | ForEach-Object {
    if($_.Version.Major -gt 3) {
        $installed = $true
    } else {
        $module = "C:\Program Files\WindowsPowerShell\Modules\Pester"
        takeown /F $module /A /R
        icacls $module /reset
        icacls $module /grant "*S-1-5-32-544:F" /inheritance:d /T
        Remove-Item -Path $module -Recurse -Force -Confirm:$false
    }
}

if(-not $installed) {
    Install-Module -Name Pester -Force -SkipPublisherCheck
}
$loadedModule = Import-Module Pester -PassThru

Invoke-Pester $PSScriptRoot\*.Tests.ps1 -Show All -CodeCoverage $PSScriptRoot\..\Functions\*.ps1 