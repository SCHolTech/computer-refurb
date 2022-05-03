Write-Host "Loading $($MyInvocation.MyCommand.Name)"
function Test-Keyboard {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        $Report
    )   

    Start-Process "https://keyboardtester.co/keyboard-tester"
    $Report.Computer.Hardware.Keyboard.TestedOk = (Read-Host -Prompt "Did the keyboard test pass? (y/n)").ToLower() -eq "y"
    if($report.Computer.Hardware.Keyboard.TestedOk -eq $false){
        $report.Computer.Hardware.Keyboard.Notes = Read-Host -Prompt "Notes on keyboard failure"
    }
    return $Report
}

Write-Host "$($MyInvocation.MyCommand.Name) Loaded."