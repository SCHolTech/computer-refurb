Write-Host "Loading $($MyInvocation.MyCommand.Name)"
function Install-PSModule {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$ModuleName
    )

    if(-not (Get-Module $ModuleName -ListAvailable)){
        Write-Host "Installing $ModuleName Module"
        Install-Module $ModuleName -Force
    } else {
        Write-Host "$ModuleName Module Installed"
    }
}
Write-Host "$($MyInvocation.MyCommand.Name) Loaded."