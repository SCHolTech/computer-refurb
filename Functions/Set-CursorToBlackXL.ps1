Write-Host "Loading $($MyInvocation.MyCommand.Name)"
function Set-CursorToBlackXL {
    Write-Host "Changing the cursor to Black XL.."
    New-ItemProperty "HKCU:\Control Panel\Cursors" -Name "(Default)" -Value "Windows Black (extra large)" -PropertyType String -Force | Out-Null
    New-ItemProperty "HKCU:\Control Panel\Cursors" -Name AppStarting -Value %SystemRoot%\cursors\wait_rl.cur -PropertyType ExpandString -Force | Out-Null
    New-ItemProperty "HKCU:\Control Panel\Cursors" -Name Arrow -Value %SystemRoot%\cursors\arrow_rl.cur -PropertyType ExpandString -Force | Out-Null
    New-ItemProperty "HKCU:\Control Panel\Cursors" -Name Crosshair -Value %SystemRoot%\cursors\cross_rl.cur -PropertyType ExpandString -Force | Out-Null
    New-ItemProperty "HKCU:\Control Panel\Cursors" -Name Hand -Value "" -PropertyType ExpandString -Force | Out-Null
    New-ItemProperty "HKCU:\Control Panel\Cursors" -Name Help -Value %SystemRoot%\cursors\help_rl.cur -PropertyType ExpandString -Force | Out-Null
    New-ItemProperty "HKCU:\Control Panel\Cursors" -Name IBeam -Value %SystemRoot%\cursors\beam_rl.cur -PropertyType ExpandString -Force | Out-Null
    New-ItemProperty "HKCU:\Control Panel\Cursors" -Name No -Value %SystemRoot%\cursors\no_rl.cur -PropertyType ExpandString -Force | Out-Null
    New-ItemProperty "HKCU:\Control Panel\Cursors" -Name NWPen -Value %SystemRoot%\cursors\pen_rl.cur -PropertyType ExpandString -Force | Out-Null
    New-ItemProperty "HKCU:\Control Panel\Cursors" -Name "Scheme Source" -Value 2 -PropertyType DWord -Force | Out-Null
    New-ItemProperty "HKCU:\Control Panel\Cursors" -Name SizeAll -Value %SystemRoot%\cursors\move_rl.cur -PropertyType ExpandString -Force | Out-Null
    New-ItemProperty "HKCU:\Control Panel\Cursors" -Name SizeNESW -Value %SystemRoot%\cursors\size1_rl.cur -PropertyType ExpandString -Force | Out-Null
    New-ItemProperty "HKCU:\Control Panel\Cursors" -Name SizeNS -Value %SystemRoot%\cursors\size4_rl.cur -PropertyType ExpandString -Force | Out-Null
    New-ItemProperty "HKCU:\Control Panel\Cursors" -Name SizeNWSE -Value %SystemRoot%\cursors\size2_rl.cur -PropertyType ExpandString -Force | Out-Null
    New-ItemProperty "HKCU:\Control Panel\Cursors" -Name SizeWE -Value %SystemRoot%\cursors\size3_rl.cur -PropertyType ExpandString -Force | Out-Null
    New-ItemProperty "HKCU:\Control Panel\Cursors" -Name UpArrow -Value %SystemRoot%\cursors\up_rl.cur -PropertyType ExpandString -Force | Out-Null
    New-ItemProperty "HKCU:\Control Panel\Cursors" -Name Wait -Value %SystemRoot%\cursors\busy_rl.cur -PropertyType ExpandString -Force | Out-Null
}
Write-Host "$($MyInvocation.MyCommand.Name) Loaded."