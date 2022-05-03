Write-Host "Loading $($MyInvocation.MyCommand.Name)"
function Test-Hotkeys {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        $Report
    )   

    $Report.Computer.Hardware.Keyboard.HotKeys.BrightnessKeysPresent = (Read-Host -Prompt "Are there brightness hotkeys? (y/n)").ToLower() -eq "y"
    if($Report.Computer.Hardware.Keyboard.HotKeys.BrightnessKeysPresent -eq $true) {
        $Report.Computer.Hardware.Keyboard.HotKeys.BrightnessKeysWorking = (Read-Host -Prompt "Do the brightness keys work? (y/n)").ToLower() -eq "y"    
    }

    $Report.Computer.Hardware.Keyboard.HotKeys.VolumeKeysPresent = (Read-Host -Prompt "Are there volume hotkeys? (y/n)").ToLower() -eq "y"
    if($Report.Computer.Hardware.Keyboard.HotKeys.VolumeKeysPresent -eq $true) {
        $Report.Computer.Hardware.Keyboard.HotKeys.VolumeKeysWorking = (Read-Host -Prompt "Do the volume keys work? (y/n)").ToLower() -eq "y"    
    }

    if(($Report.Computer.Hardware.Keyboard.HotKeys.BrightnessKeysPresent -eq $true -and $Report.Computer.Hardware.Keyboard.HotKeys.BrightnessKeysWorking -eq $false) -or 
    ($Report.Computer.Hardware.Keyboard.HotKeys.VolumeKeysPresent -eq $true -and $Report.Computer.Hardware.Keyboard.HotKeys.VolumeKeysWorking -eq $false)){
        $Report.Computer.Hardware.Keyboard.HotKeys.Notes = Read-Host -Prompt "Enter any hotkey notes"
    }
    
    return $Report
}

Write-Host "$($MyInvocation.MyCommand.Name) Loaded."