Write-Host "Loading $($MyInvocation.MyCommand.Name)"
function Copy-ToLocal {
    
    $currentLocation = Get-Location

    $localDisk = "$($env:SystemDrive)\"
    $localFolder = "SCHolTechSetup"
    $localFolderPath = [System.IO.Path]::Combine($localDisk, $localFolder)

    if((Test-Path -Path $localFolderPath) -eq $false){
        New-Item -Path $localFolderPath -ItemType Directory | Out-Null
    }
    Copy-Item -Path "$($currentLocation)\*" -Destination $localFolderPath -Recurse -Exclude @("Tests", "Reports") | Out-Null
    New-Item -Path ([System.IO.Path]::Combine($localFolderPath.ToString(), "Reports")) -ItemType Directory | Out-Null

    return $localFolderPath
}
Write-Host "$($MyInvocation.MyCommand.Name) Loaded."