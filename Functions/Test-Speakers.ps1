Write-Host "Loading $($MyInvocation.MyCommand.Name)"
function Test-Speakers {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        $Report
    )   

    $Report.Computer.Hardware.Speakers.Present = (Read-Host -Prompt "Are speakers present? (y/n)").ToLower() -eq "y"

    if($Report.Computer.Hardware.Speakers.Present -eq $true) {
        Start-Process "https://www.youtube.com/watch?v=2ZrWHtvSog4"
        $Report.Computer.Hardware.Speakers.TestedOk = (Read-Host -Prompt "Did the speaker test pass? (y/n)").ToLower() -eq "y"
        if($report.Computer.Hardware.Speakers.TestedOk -eq $false){
            $report.Computer.Hardware.Speakers.Notes = Read-Host -Prompt "Notes on speaker failure"
        }
        
    } else {
        $Report.Computer.Hardware.Speakers.TestedOk = $null
        $report.Computer.Hardware.Speakers.Notes = $null
    }

    return $Report
}

Write-Host "$($MyInvocation.MyCommand.Name) Loaded."