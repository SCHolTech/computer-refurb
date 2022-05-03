Write-Host "Loading $($MyInvocation.MyCommand.Name)"
function Write-LocalLog {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    
    $fileexists = (Test-Path -Path "C:\schol-setup.txt")
    if(-not $fileexists){
        New-Item -Path "C:\schol-setup.txt" -ItemType File
    }
    Add-Content -Path "C:\schol-setup.txt" -Value ([string]::Format("{0}    {1}", [datetime]::Now.ToString("dd-MM-yyyy HH:mm:ss"),  $Message))
}
Write-Host "$($MyInvocation.MyCommand.Name) Loaded."