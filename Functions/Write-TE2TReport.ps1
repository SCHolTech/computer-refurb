Write-Host "Loading $($MyInvocation.MyCommand.Name)"
. $PSScriptRoot\Write-Result.ps1
function Write-TE2TReport {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        $Report
    )
    Write-Host ""
    Write-Result -Key "Make / Model" -Value ("{0} {1}" -f $Report.Computer.Manufacturer, $Report.Computer.Model)
    Write-Result -Key "SCHOL Laptop Number" -Value $Report.Computer.SCHolTechNumber
    Write-Result -Key "OS" -Value $Report.Computer.Software.Windows.Version
    $Report.Computer.Hardware.Disks | ForEach-Object{
        Write-Result -Key "Disk" -Value ("{0}GB {1} ({2})" -f ($_.Size/1GB).ToString("N2"), $_.Name, $_.Type)
    }
    Write-Result -Key "SCHOL Grade" -Value $Report.Computer.ScholGrade
    Write-Result -Key "SCHOL Grade Rationale" -Value $Report.Computer.ScholGradeRationale
    Write-Result -Key "SCHOL Status" -Value $Report.Computer.SCHolStatus
    Write-Result -Key "Battery present?" -Value $Report.Computer.Hardware.Battery.Present
    Write-Result -Key "Battery holds charge?" -Value ($Report.Computer.Hardware.Battery.ApproximateChargeInMinutes -gt 0)
    Write-Result -Key "Battery charge in minutes?" -Value $Report.Computer.Hardware.Battery.ApproximateChargeInMinutes
    Write-Result -Key "Charger tested ok?" -Value $Report.Computer.Hardware.Charger.TestedOk

    Write-Result -Key "BIOS Manufacturer" -Value $Report.Computer.Hardware.MainBoard.BIOS.Manufacturer
    Write-Result -Key "BIOS Name" -Value $Report.Computer.Hardware.MainBoard.BIOS.Name
    Write-Result -Key "BIOS Release Date" -Value $Report.Computer.Hardware.MainBoard.BIOS.ReleaseDate
    Write-Result -Key "BIOS Version" -Value $Report.Computer.Hardware.MainBoard.BIOS.Version
    Write-Result -Key "Total Memory" -Value ("{0} GB" -f (($Report.Computer.Hardware.MemoryModules.Size | Measure-Object -Sum).Sum/1GB))
    $Report.Computer.Hardware.MemoryModules | ForEach-Object {
        Write-Result -Key "Module" -Value ("{0} {1}GB {2}Mhz @ {3}Mhz" -f $_.Manufacturer, ($_.Size/1GB), $_.Speed, $_.ConfiguredSpeed)
    }
    Write-Result -Key "Processor" -Value ("{0} {1} {2} Cores {3} Threads @ {4}Mhz" -f $Report.Computer.Hardware.Processor.Manufacturer, $Report.Computer.Hardware.Processor.Model, `
    $Report.Computer.Hardware.Processor.Cores, $Report.Computer.Hardware.Processor.Threads, $Report.Computer.Hardware.Processor.ClockSpeed)
    Write-Result -Key "Camera quality" -Value $Report.Computer.Hardware.Camera.Quality
    Write-Result -Key "Mic quality" -Value $Report.Computer.Hardware.Microphone.Quality
    Write-Host ""

    if($Report.ReportVersion -ge 2.2) {
        $Report.Computer.Hardware.Keyboard.Languages | ForEach-Object {
            Write-Result -Key "Keyboard Language" -Value $_
        }
    }

    Write-Host ""
    Write-Result -Key "NOTES" -Value ""

    if(![string]::IsNullOrEmpty($report.Computer.Software.Zoom.Notes)){
        Write-Result -Key "Zoom notes" -Value $report.Computer.Software.Zoom.Notes
    }
    if(![string]::IsNullOrEmpty($report.Computer.Hardware.Keyboard.Notes)){
        Write-Result -Key "Keyboard notes" -Value $report.Computer.Hardware.Keyboard.Notes
    }
    if(![string]::IsNullOrEmpty($report.Computer.Hardware.Keyboard.HotKeys.Notes)){
        Write-Result -Key "Hotkeys keys notes" -Value $report.Computer.Hardware.Keyboard.HotKeys.Notes
    }


    function Write-TrackpadNotes{
        [CmdletBinding()]
        param (
            [Parameter(Mandatory=$true)]
            $Report
        )       
        if(![string]::IsNullOrEmpty($Report.Computer.Hardware.Trackpad.Notes)){
            Write-Result -Key "Trackpad notes" -Value $Report.Computer.Hardware.Trackpad.Notes
        }
    }

    if($report.ReportVersion -eq 2.0){
        Write-TrackpadNotes -Report $report
    } elseif($report.ReportVersion -ge 2.1 -and $report.Computer.Hardware.TrackPad.Present -eq $true) {
        Write-TrackpadNotes -Report $report
    }

    function Write-MouseNotes{
        [CmdletBinding()]
        param (
            [Parameter(Mandatory=$true)]
            $Report
        )       
        if(![string]::IsNullOrEmpty($Report.Computer.Hardware.Mouse.Notes)){
            Write-Result -Key "Mouse notes" -Value $Report.Computer.Hardware.Mouse.Notes
        }
    }

    if($report.ReportVersion -ge 2.1 -and $report.Computer.Hardware.Mouse.Present -eq $true){
        Write-MouseNotes -Report $report
    }

    if(![string]::IsNullOrEmpty($report.Computer.Hardware.Speakers.Notes)){
        Write-Result -Key "Speaker notes" -Value $report.Computer.Hardware.Speakers.Notes
    }
    if(![string]::IsNullOrEmpty($report.Computer.Notes)){
        Write-Result -Key "General notes" -Value $report.Computer.Notes
    }
    Write-Host ""

    Write-Result -Key "Benchmark Url" -Value $report.Computer.Benchmark.BenchmarkUrl

}
Write-Host "$($MyInvocation.MyCommand.Name) Loaded."