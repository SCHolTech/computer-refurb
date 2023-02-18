. $PSScriptRoot\Functions\Set-NextScript.ps1
. $PSScriptRoot\Functions\Get-Report.ps1
. $PSScriptRoot\Functions\Set-Report.ps1
. $PSScriptRoot\Functions\Set-LanguageSwitches.ps1
. $PSScriptRoot\Functions\Write-LocalLog.ps1

function Assert-TeamsIsInstalled {
    $exists = (Test-Path -Path "$Env:APPDATA\Microsoft\Windows\Start Menu\Programs\Microsoft Teams.lnk")
    if(-not $exists) {
        Write-Host "Teams not installed yet. Waiting 10 seconds..."
        Start-Sleep -Seconds 10
        Assert-TeamsIsInstalled
    } else {
        Write-Host "Teams installed successfully. Continuing.."
    }
}

Set-Location $PSScriptRoot
Write-LocalLog -Message "Begin $($MyInvocation.MyCommand.Name)"
Write-Host "The computer is currently named $env:computername"
$report = Get-Report

Assert-TeamsIsInstalled
$report.Computer.Software.MSTeams.Present = $true

Write-Host "Laying out the taskbar.."
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Search -Name "SearchboxTaskbarMode" -Value "1" -PropertyType DWORD -Force | Out-Null
$report.Computer.Software.Windows.Taskbar.SearchboxIcon = $true
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name "ShowTaskViewButton" -Value "0" -PropertyType DWORD -Force | Out-Null
$report.Computer.Software.Windows.Taskbar.TaskViewRemoved = $true
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name "ShowCortanaButton" -Value "0" -PropertyType DWORD -Force | Out-Null
$report.Computer.Software.Windows.Taskbar.CortanaRemoved = $true

$windowsFeedRegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds"
$feedsTaskbarRegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds"
if ( -Not ( Test-Path $windowsFeedRegistryPath ) ) {
    New-Item -Path $windowsFeedRegistryPath -ItemType RegistryKey -Force
}
New-ItemProperty -Path $windowsFeedRegistryPath -Name "EnableFeeds" -Value "0" -PropertyType DWORD -Force | Out-Null
 
if ( -Not ( Test-Path $feedsTaskbarRegistryPath ) ) {
    New-Item -Path $feedsTaskbarRegistryPath -ItemType RegistryKey -Force
}
New-ItemProperty -Path $feedsTaskbarRegistryPath -Name "ShellFeedsTaskbarViewMode" -Value "2" -PropertyType DWORD -Force | Out-Null
$report.Computer.Software.Windows.Taskbar.NewsAndInterestsRemoved = $true

Write-Host "Laying out the Desktop.."
Write-Host "Deleting existing items.."
Remove-Item -Path $env:PUBLIC\Desktop\* -Force
Remove-Item -Path $env:USERPROFILE\Desktop\* -Force
Start-Sleep -Seconds 10
Write-Host "Adding new items.."
Copy-Item -Path "$Env:ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" -Destination "$env:USERPROFILE\Desktop\Microsoft Edge.lnk"
Start-Sleep -Seconds 2
Copy-Item -Path "$Env:ProgramData\Microsoft\Windows\Start Menu\Programs\LibreOffice 7.4\LibreOffice Writer.lnk" -Destination $env:USERPROFILE\Desktop\Documents.lnk
Start-Sleep -Seconds 2
Copy-Item -Path "$Env:APPDATA\Microsoft\Windows\Start Menu\Programs\Microsoft Teams.lnk" -Destination "$env:USERPROFILE\Desktop\Microsoft Teams.lnk"
Start-Sleep -Seconds 2
Copy-Item -Path "$Env:ProgramData\Microsoft\Windows\Start Menu\Programs\Zoom\Zoom.lnk" -Destination $env:USERPROFILE\Desktop\Zoom.lnk
Start-Sleep -Seconds 2
New-Item -Path "$env:USERPROFILE\Desktop" -Name "Click World Icon for Wifi" -ItemType Directory | Out-Null
Start-Sleep -Seconds 1
Set-LanguageSwitches -LanguageOption $report.RefurbOptions.LanguageSetup
$report.Computer.Software.Windows.Desktop.IconsSet = $true
New-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\Shell\Bags\1\Desktop" -Name "FFlags" -Value "1075839520" -PropertyType DWORD -Force | Out-Null
$report.Computer.Software.Windows.Desktop.SnapToGridOff = $true

Write-Host "Laying Out The Start Menu.."
Copy-Item ".\Assets\Microsoft Edge.lnk" -Destination "$env:USERPROFILE\links\Microsoft Edge.lnk" -Force
[LanguageOptions]$langOption = $report.RefurbOptions.LanguageSetup
if($langOption -eq [LanguageOptions]::UkraineKbdEnglishUkraineUI){
    Copy-Item "C:\LanguageSwitches\ToEnglish\English - Англійська.lnk" -Destination "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\English - Англійська.lnk" -Force
    Copy-Item "C:\LanguageSwitches\ToUkrainian\українська - Ukrainian.lnk" -Destination "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\українська - Ukrainian.lnk" -Force
    Start-Sleep -Seconds 5
    Copy-Item -Path ".\Assets\StartMenuLayouts\startUkraineKbdEnglishUkraineUI.xml" -Destination $env:LOCALAPPDATA\Microsoft\Windows\Shell\LayoutModification.xml -Force
} elseif($langOption -eq [LanguageOptions]::RussianKbdEnglishUrkraineRussianUI){
    Copy-Item "C:\LanguageSwitches\ToEnglish\English (Англійська - Английский).lnk" -Destination "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\English (Англійська - Английский).lnk" -Force
    Copy-Item "C:\LanguageSwitches\ToRussianUkrainian\русский (Russian - Російська).lnk" -Destination "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\русский (Russian - Російська).lnk" -Force
    Copy-Item "C:\LanguageSwitches\ToUkrainian\українська (Ukrainian - Украинский).lnk" -Destination "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\українська (Ukrainian - Украинский).lnk" -Force
    Start-Sleep -Seconds 5
    Copy-Item -Path ".\Assets\StartMenuLayouts\startRussianKbdEnglishUrkraineRussianUI.xml" -Destination $env:LOCALAPPDATA\Microsoft\Windows\Shell\LayoutModification.xml -Force
} else {
    Copy-Item -Path ".\Assets\StartMenuLayouts\start.xml" -Destination $env:LOCALAPPDATA\Microsoft\Windows\Shell\LayoutModification.xml -Force
}

Remove-Item -Force -Recurse -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store"
$report.Computer.Software.Windows.StartMenu.Arranged = $true

taskkill /f /im explorer.exe
Start-Process explorer.exe

Set-Report -Report $report
Set-NextScript -StepName "SCHOLStep" -ScriptAbsolutePath $PSScriptRoot\setup-stage030.ps1
Write-LocalLog -Message "Completed $($MyInvocation.MyCommand.Name)"
Restart-Computer -Force