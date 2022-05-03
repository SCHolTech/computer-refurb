Write-Host "Loading $($MyInvocation.MyCommand.Name)"
function Test-Battery {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        $Report
    )   
    
    $Report.Computer.Hardware.Battery.Present = (Read-Host -Prompt "Battery present? (y/n)").ToLower() -eq "y"

    if($Report.Computer.Hardware.Battery.Present) {
        if((Read-Host -Prompt "Holds charge? (y/n)").ToLower() -eq "y") {
            $Report.Computer.Hardware.Battery.ApproximateChargeInMinutes = Read-Host -Prompt "Approximate charge in minutes"
        } else {
            $Report.Computer.Hardware.Battery.ApproximateChargeInMinutes = 0
        }
    }

    return $Report
}

Write-Host "$($MyInvocation.MyCommand.Name) Loaded."