Write-Host "Loading $($MyInvocation.MyCommand.Name)"
function Set-SCHolTechWallpaper {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$WallpaperFolderPath
    )
    Write-Host "Setting Desktop Wallpaper.."
    Add-Type -AssemblyName System.Windows.Forms
    $desktop = "$WallpaperFolderPath\SCHol-Background-1920x1080.png"
    $width = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Width
    $height = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Height
    $bestMatchDesktop = "$WallpaperFolderPath\SCHol-Background-{0}x{1}.png" -f $width,$height
    if(Test-Path $bestMatchDesktop){
        $desktop = $bestMatchDesktop
    }
    New-Item $env:USERPROFILE\Pictures\DesktopBackgrounds -ItemType Directory -Force | Out-Null
    Copy-Item $desktop -Destination $env:USERPROFILE\Pictures\DesktopBackgrounds\background.png -Force
    New-ItemProperty 'HKCU:\Control Panel\Desktop' -Name "WallPaper" -Value $env:USERPROFILE\Pictures\DesktopBackgrounds\background.png -Force | Out-Null
}
Write-Host "$($MyInvocation.MyCommand.Name) Loaded."