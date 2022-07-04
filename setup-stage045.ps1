. $PSScriptRoot\Functions\Get-Report.ps1
. $PSScriptRoot\Functions\Set-Report.ps1
. $PSScriptRoot\Functions\Write-Report.ps1
. $PSScriptRoot\Functions\Write-LocalLog.ps1

Set-Location $PSScriptRoot
Write-LocalLog -Message "Begin $($MyInvocation.MyCommand.Name)"
Write-Host "The computer is currently named $env:computername"
$report = Get-Report

$userBenchmarkFile = "UserBenchMark.exe"
$userBenchmarkFilePath = "$PSScriptRoot\Software\$userBenchmarkFile"
$userBenchmarkExists = Test-Path -Path $userBenchmarkFilePath
if($userBenchmarkExists -eq $false) {
    Write-Host "Downloading $userBenchmarkFile..."
    Invoke-WebRequest -Uri "https://scholtech.blob.core.windows.net/software/$userBenchmarkFile" -OutFile $userBenchmarkFilePath
}
Start-Process -FilePath $PSScriptRoot\Software\UserBenchMark.exe
$report.Computer.Benchmark.OverallScore = Read-Host -Prompt "Benchmark Score"
$report.Computer.Benchmark.CPUSingleScore = Read-Host -Prompt "Benchmark Single CPU Score"
$report.Computer.Benchmark.CPUGamingScore = Read-Host -Prompt "Benchmark Gaming CPU Score"
$report.Computer.Benchmark.BenchmarkUrl = Read-Host -Prompt "Enter Benchmark Url"
Set-Report -Report $report


$report.Computer.SCHolStatus = Read-Host -Prompt "RTS or NR"
$report.Computer.ScholGrade = Read-Host -Prompt "SCHol Grade"
$report.Computer.ScholGradeRationale = Read-Host -Prompt "Grade Rational"
$report.Computer.Notes = Read-Host -Prompt "Add any generic notes:"
Set-Report -Report $report

$report.Computer.Software.Windows.WirelessNetworksRemoved = $true

Set-Report -Report $report
Write-Report -Report $report

# [string]$currentLocation = Get-Location
# if($currentLocation.StartsWith($env:SystemDrive)){
#     Set-Report -Report $report -SaveLocation "\\192.168.0.200\schol\v2"
#     Remove-Item $PSScriptRoot -Recurse -Force
# }

Read-Host -Prompt "When you are ready to remove wifi connections, hit enter"
Write-Host "Removing wifi..."
$list=(netsh.exe wlan show profiles) -match ':'
for ($i=1; $i -lt $list.count; $i++) {
    netsh wlan delete profile $list[$i].split(":")[1].Trim()
}
Write-LocalLog -Message "Completed $($MyInvocation.MyCommand.Name)"