Write-Host "Loading $($MyInvocation.MyCommand.Name)"
function Install-MSIPackage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Arguments,
        [Parameter(Mandatory=$true)]
        [string]$PackageName,
        [string]$TestPath
    ) 
    
    Write-Host "Installing $PackageName..."
    Start-Process msiexec -ArgumentList $Arguments -Wait

    if(-not [string]::IsNullOrEmpty($TestPath)){
        return Test-Path $TestPath
    } else {
        return $null
    }
}

Write-Host "$($MyInvocation.MyCommand.Name) Loaded."