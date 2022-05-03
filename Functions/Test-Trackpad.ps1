Write-Host "Loading $($MyInvocation.MyCommand.Name)"
function Test-Trackpad {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        $Report
    ) 

    $Report.Computer.Hardware.Trackpad.Present = (Read-Host -Prompt "Is there a trackpad? (y/n)").ToLower() -eq "y"
    
    if($Report.Computer.Hardware.Trackpad.Present -eq $true) {   
        Start-Process -FilePath main.cpl
        Start-Process -FilePath ms-settings:devices-touchpad
        
        Read-Host -Prompt "Configure the trackpad and hit any key to continue" | Out-Null

        $Report.Computer.Hardware.Trackpad.LeftClickOk = (Read-Host -Prompt "Does the left trackpad button work? (y/n)").ToLower() -eq "y"
        $Report.Computer.Hardware.Trackpad.RightClickOk = (Read-Host -Prompt "Does the right trackpad button work? (y/n)").ToLower() -eq "y"
        $Report.Computer.Hardware.Trackpad.TwoFingerScroll = (Read-Host -Prompt "Does 2-finger scroll work? (y/n)").ToLower() -eq "y"
        $Report.Computer.Hardware.Trackpad.NoGestures = (Read-Host -Prompt "Are 3 and 4 finger tap and flick turned off? (y/n)").ToLower() -eq "y"
        
        if($Report.Computer.Hardware.Trackpad.LeftClickOk -eq $false -or
        $Report.Computer.Hardware.Trackpad.RightClickOk -eq $false -or
        $Report.Computer.Hardware.Trackpad.TwoFingerScroll -eq $false -or
        $Report.Computer.Hardware.Trackpad.NoGestures -eq $false) {
            $Report.Computer.Hardware.Trackpad.Notes = Read-Host -Prompt "Please add any trackpad notes"
        }
    } else {
        $Report.Computer.Hardware.Trackpad.Notes = $null
        $Report.Computer.Hardware.Trackpad.LeftClickOk = $null
        $Report.Computer.Hardware.Trackpad.RightClickOk = $null
        $Report.Computer.Hardware.Trackpad.TwoFingerScroll = $null
        $Report.Computer.Hardware.Trackpad.NoGestures = $null
    }
    return $Report
}

Write-Host "$($MyInvocation.MyCommand.Name) Loaded."