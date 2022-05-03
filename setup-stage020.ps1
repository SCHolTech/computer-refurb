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

Install-MSIPackage -PackageName "Microsoft Teams" -Arguments "/i $PSScriptRoot\Software\Teams_windows_x64.msi OPTIONS=""noAutoStart=true"" ALLUSERS=1"
$report.Computer.Software.LibreOffice.Present = Install-MSIPackage -PackageName "Libre Office" `
-Arguments "/i $PSScriptRoot\Software\LibreOffice_7.2.6_Win_x64.msi ADDLOCAL=ALL RebootYesNo=No /qn" -TestPath "C:\Program Files\LibreOffice\program\soffice.exe"
$report.Computer.Software.Zoom.Present = Install-MSIPackage -PackageName "Zoom" `
-Arguments "/i $PSScriptRoot\Software\ZoomInstallerFull.msi /quiet /qn /norestart" -TestPath "C:\Program Files\Zoom\bin\Zoom.exe"
$report.Computer.Software.Edge.Present = Install-MSIPackage -PackageName "Microsoft Edge" `
-Arguments "/i $PSScriptRoot\Software\MicrosoftEdgeEnterprisex64.msi /quiet /norestart" -TestPath "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"

Set-SCHolTechWallpaper -WallpaperFolderPath "$PSScriptRoot\DesktopBackgrounds"
$report.Computer.Software.Windows.Desktop.SCHolTechWallpaperSet = $true

Set-CursorToBlackXL
$report.Computer.Software.Windows.Cursor.SchemeSetToBlackXL = $true

Set-Report -Report $report
Set-NextScript -StepName "SCHOLStep2" -ScriptAbsolutePath $PSScriptRoot\setup-stage025.ps1
Write-LocalLog -Message "Completed $($MyInvocation.MyCommand.Name)"
Restart-Computer -Force