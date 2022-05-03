Write-Host "Loading $($MyInvocation.MyCommand.Name)"
function Test-Mouse {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        $Report
    ) 

    $Report.Computer.Hardware.Mouse.Present = (Read-Host -Prompt "Is there a mouse? (y/n)").ToLower() -eq "y"
    
    if($Report.Computer.Hardware.Mouse.Present -eq $true) {   

        $Report.Computer.Hardware.Mouse.LeftClickOk = (Read-Host -Prompt "Does the left mouse button work? (y/n)").ToLower() -eq "y"
        $Report.Computer.Hardware.Mouse.RightClickOk = (Read-Host -Prompt "Does the right mouse button work? (y/n)").ToLower() -eq "y"
        $Report.Computer.Hardware.Mouse.ScrollWheelOk = (Read-Host -Prompt "Does the scroll wheel work? (y/n)").ToLower() -eq "y"
        
        if($Report.Computer.Hardware.Mouse.LeftClickOk -eq $false -or
        $Report.Computer.Hardware.Mouse.RightClickOk -eq $false -or
        $Report.Computer.Hardware.Mouse.ScrollWheelOk -eq $false) {
            $Report.Computer.Hardware.Mouse.Notes = Read-Host -Prompt "Please add any mouse notes"
        }
    } else {
        $Report.Computer.Hardware.Mouse.Notes = $null
        $Report.Computer.Hardware.Mouse.LeftClickOk = $null
        $Report.Computer.Hardware.Mouse.RightClickOk = $null
        $Report.Computer.Hardware.Mouse.ScrollWheelOk = $null
    }
    return $Report
}

Write-Host "$($MyInvocation.MyCommand.Name) Loaded."