Write-Host "Loading $($MyInvocation.MyCommand.Name)"
. $PSScriptRoot\Write-Result.ps1
function Write-W11Report {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        $Report
    )
    Write-Result -Key "Windows 11 Compatibility Report" -Value ""

    Write-Result -Key "CPU (Dual core 1 Ghz)" -Value `
    ($Report.Computer.Hardware.Processor.ClockSpeed -ge 1000 -and `
    $Report.Computer.Hardware.Processor.Cores -ge 2)

    Write-Result -Key "Memory (Min 4GB)" -Value `
    (($Report.Computer.Hardware.MemoryModules.Size | Measure-Object -Sum).Sum -ge 4GB)

    Write-Result -Key "Storage (Min 64GB)" -Value `
    (($Report.Computer.Hardware.Disks.Size | Measure-Object -Sum).Sum -ge 64GB)

    Write-Result -Key "Firmware (UEFI)" -Value `
    ($Report.Computer.Hardware.MainBoard.BIOS.UEFI -eq $true)

    Write-Result -Key "Secure Boot (Enabled)" -Value `
    ($Report.Computer.Hardware.MainBoard.BIOS.SecureBootEnabled -eq $true)

    Write-Result -Key "TPM (v2)" -Value `
    ($Report.Computer.Hardware.MainBoard.TPM.Present -and $Report.Computer.Hardware.MainBoard.TPM.Version -eq "2.0")

    Write-Result -Key "Display (720p, 9`", 24bit)" -Value `
    ($Report.Computer.Hardware.Screen.DiagonalSize -gt 9 -and `
    $Report.Computer.Hardware.Screen.PixelsWide -ge 1280 -and `
    $Report.Computer.Hardware.Screen.PixelsHigh -ge 720)


    [decimal]$WDDM = 0
    [decimal]$DxLevel = 0
    $Report.Computer.Hardware.GraphicsAdapters | ForEach-Object {
        $adapter = $_
        [decimal]$adapterWDDM = $adapter.WDDMLevel.Replace("WDDM ", "")
        if($WDDM -lt $adapterWDDM) {
            $WDDM = $adapterWDDM
        }

        [decimal]$adapterDx = ($adapter.DxFeatureLevels.Replace("_", ".").Split(",") | Measure-Object -Maximum).Maximum
        if($DxLevel -lt $adapterDx) {
            $DxLevel = $adapterDx
        }
    }

    Write-Result -Key "Graphics" -Value ($WDDM -ge 2.0 -and $DxLevel -ge 12)
        Write-Host ""
}
Write-Host "$($MyInvocation.MyCommand.Name) Loaded."