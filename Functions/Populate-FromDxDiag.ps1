Write-Host "Loading $($MyInvocation.MyCommand.Name)"
function Populate-FromDxDiag {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        $Report
    ) 
    
    if($null -eq $Report.Computer.Hardware){
        $Report.Computer.Hardware = @{}
    }
    if($null -eq $Report.Computer.Hardware.GraphicsAdapters){
        $Report.Computer.Hardware.GraphicsAdapters = @()
    }


    dxdiag /x C:\dxdiag.xml
    $counter = 0
    while (-not (Test-Path C:\dxdiag.xml) -or $counter -ge 12 ) {
        Write-Host "Waiting for dxdiag results..."
        Start-Sleep -Seconds 5
        $counter++
    }

    $Report.Computer.Hardware.GraphicsAdapters = @()
    Select-Xml -Path C:\dxdiag.xml -XPath '/DxDiag/DisplayDevices/DisplayDevice' | ForEach-Object { 
        $adapter = @{
            Name = $_.Node.CardName
            Chip = $_.Node.ChipType
            DxFeatureLevels = $_.Node.FeatureLevels
            WDDMLevel = $_.Node.DriverModel
        }

        if($null -ne $_.Node.CurrentMode) {
            $adapter.CurrentDisplayMode = $_.Node.CurrentMode
        }
        $Report.Computer.Hardware.GraphicsAdapters += $adapter
    }

    Remove-Item C:\dxdiag.xml

    Add-Type -AssemblyName System.Windows.Forms
    $Report.Computer.Hardware.Screen.DiagonalSize = (Get-WmiObject -Namespace root\wmi -Class WmiMonitorBasicDisplayParams | `
    Select-Object @{N="Size"; E={[System.Math]::Round(([System.Math]::Sqrt([System.Math]::Pow($_.MaxHorizontalImageSize, 2) + [System.Math]::Pow($_.MaxVerticalImageSize, 2))/2.54),2)} }).Size
    $Report.Computer.Hardware.Screen.PixelsWide = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Width
    $Report.Computer.Hardware.Screen.PixelsHigh = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Height
    $Report.Computer.Hardware.Screen.BitDepth = (Get-CimInstance -ClassName Win32_VideoController -Property CurrentBitsPerPixel).CurrentBitsPerPixel


    return $Report
}

Write-Host "$($MyInvocation.MyCommand.Name) Loaded."