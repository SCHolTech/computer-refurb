Write-Host "Loading $($MyInvocation.MyCommand.Name)"
function Set-Report {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        $Report,
        [string]$SaveLocation
    )
    if([string]::IsNullOrEmpty($SaveLocation)) {
        ConvertTo-Json $Report -Depth 10 | Out-File $PSScriptRoot\..\Reports\$env:COMPUTERNAME.json -Force
    } else {
        ConvertTo-Json $Report -Depth 10 | Out-File $SaveLocation\Reports\$env:COMPUTERNAME.json -Force
    }
    
}
Write-Host "$($MyInvocation.MyCommand.Name) Loaded."