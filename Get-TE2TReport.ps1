. $PSScriptRoot\Functions\Write-TE2TReport.ps1
. $PSScriptRoot\Functions\Write-W11Report.ps1
$laptopId = Read-Host -Prompt "Please enter the laptop Id"
$report = Get-Content -Path "\\192.168.0.200\schol\v2\Reports\SCHOL-T$laptopId.json" | ConvertFrom-Json
Write-TE2TReport -Report $report
Write-W11Report -Report $report