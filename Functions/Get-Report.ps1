Write-Host "Loading $($MyInvocation.MyCommand.Name)"
function Get-Report {
    if(Test-Path $PSScriptRoot\..\Reports\$env:COMPUTERNAME.json){
        $report = Get-Content $PSScriptRoot\..\Reports\$env:COMPUTERNAME.json | ConvertFrom-Json
    } else {
        $report = Get-Content $PSScriptRoot\..\Assets\BaseReport.2.0.json | ConvertFrom-Json   
    }
    return $report
}
Write-Host "$($MyInvocation.MyCommand.Name) Loaded."