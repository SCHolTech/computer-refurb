. $PSScriptRoot\Functions\Set-SCHolTechWallpaper.ps1
. $PSScriptRoot\Functions\Set-CursorToBlackXL.ps1
. $PSScriptRoot\Functions\Set-NextScript.ps1
. $PSScriptRoot\Functions\Get-Report.ps1
. $PSScriptRoot\Functions\Set-Report.ps1
. $PSScriptRoot\Functions\Write-LocalLog.ps1
. $PSScriptRoot\Functions\Populate-FromComputerInfo.ps1
. $PSScriptRoot\Functions\Populate-FromDxDiag.ps1
. $PSScriptRoot\Functions\Install-MSIPackage.ps1

Set-Location $PSScriptRoot
Write-LocalLog -Message "Begin $($MyInvocation.MyCommand.Name)"
Write-Host "The computer is currently named $env:computername"
$report = Get-Report
$report.Computer.Software.Windows.IsActivated = ((Get-CimInstance SoftwareLicensingProduct -Filter "Name like 'Windows%'" | Where-Object { $_.PartialProductKey }).LicenseStatus -eq 1)
$report = Populate-FromComputerInfo -Report $report
$report = Populate-FromDxDiag -Report $report


$teamsInstallerFile = "Teams_windows_x64.msi"
$teamsInstallerFilePath = "$PSScriptRoot\Software\$teamsInstallerFile"
$teamsInstallerExists = Test-Path -Path $teamsInstallerFilePath
if($teamsInstallerExists -eq $false) {
    Write-Host "Downloading $teamsInstallerFile..."
    Invoke-WebRequest -Uri "https://scholtech.blob.core.windows.net/software/$teamsInstallerFile" -OutFile $teamsInstallerFilePath
}
Install-MSIPackage -PackageName "Microsoft Teams" -Arguments "/i $teamsInstallerFilePath OPTIONS=""noAutoStart=true"" ALLUSERS=1"


$libreOfficeInstallerFile = "LibreOffice_7.4.5_Win_x64.msi"
$libreOfficeInstallerFilePath = "$PSScriptRoot\Software\$libreOfficeInstallerFile"
$libreOfficeInstallerExists = Test-Path -Path $libreOfficeInstallerFilePath
if($libreOfficeInstallerExists -eq $false) {
    Write-Host "Downloading $libreOfficeInstallerFile..."
    Invoke-WebRequest -Uri "https://scholtech.blob.core.windows.net/software/$libreOfficeInstallerFile" -OutFile $libreOfficeInstallerFilePath
}
$report.Computer.Software.LibreOffice.Present = Install-MSIPackage -PackageName "Libre Office" `
-Arguments "/i $libreOfficeInstallerFilePath ADDLOCAL=ALL RebootYesNo=No /qn" -TestPath "C:\Program Files\LibreOffice\program\soffice.exe"


$zoomInstallerFile = "ZoomInstallerFull.msi"
$zoomInstallerFilePath = "$PSScriptRoot\Software\$zoomInstallerFile"
$zoomInstallerExists = Test-Path -Path $zoomInstallerFilePath
if($zoomInstallerExists -eq $false) {
    Write-Host "Downloading $zoomInstallerFile..."
    Invoke-WebRequest -Uri "https://scholtech.blob.core.windows.net/software/$zoomInstallerFile" -OutFile $zoomInstallerFilePath
}
$report.Computer.Software.Zoom.Present = Install-MSIPackage -PackageName "Zoom" `
-Arguments "/i $zoomInstallerFilePath /quiet /qn /norestart" -TestPath "C:\Program Files\Zoom\bin\Zoom.exe"


$edgeInstallerFile = "MicrosoftEdgeEnterprisex64.msi"
$edgeInstallerFilePath = "$PSScriptRoot\Software\$edgeInstallerFile"
$edgeInstallerExists = Test-Path -Path $edgeInstallerFilePath
if($edgeInstallerExists -eq $false) {
    Write-Host "Downloading $edgeInstallerFile..."
    Invoke-WebRequest -Uri "https://scholtech.blob.core.windows.net/software/$edgeInstallerFile" -OutFile $edgeInstallerFilePath
}
$report.Computer.Software.Edge.Present = Install-MSIPackage -PackageName "Microsoft Edge" `
-Arguments "/i $edgeInstallerFilePath /quiet /norestart" -TestPath "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"


Set-SCHolTechWallpaper -WallpaperFolderPath "$PSScriptRoot\DesktopBackgrounds"
$report.Computer.Software.Windows.Desktop.SCHolTechWallpaperSet = $true

Set-CursorToBlackXL
$report.Computer.Software.Windows.Cursor.SchemeSetToBlackXL = $true

Set-Report -Report $report
Set-NextScript -StepName "SCHOLStep2" -ScriptAbsolutePath $PSScriptRoot\setup-stage025.ps1
Write-LocalLog -Message "Completed $($MyInvocation.MyCommand.Name)"
Restart-Computer -Force