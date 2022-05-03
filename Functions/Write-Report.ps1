Write-Host "Loading $($MyInvocation.MyCommand.Name)"
. $PSScriptRoot\Write-Result.ps1
function Write-Report {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        $Report
    )

    Write-Result -Key "Computer Name" -Value $Report.Computer.Software.Windows.ComputerName
    Write-Result -Key "SCHOL Laptop Number" -Value $Report.Computer.SCHolTechNumber

    Write-Result -Key "SCHOL Status" -Value $Report.Computer.SCHolStatus
    Write-Result -Key "SCHOL Grade" -Value $Report.Computer.ScholGrade
    Write-Result -Key "SCHOL Grade Rationale" -Value $Report.Computer.ScholGradeRationale

    Write-Result -Key "Make / Model" -Value ("{0} {1}" -f $Report.Computer.Manufacturer, $Report.Computer.Model)
    Write-Result -Key "Processor" -Value ("{0} {1} {2} Cores {3} Threads @ {4}Mhz" -f $report.Computer.Hardware.Processor.Manufacturer, $report.Computer.Hardware.Processor.Model, `
    $report.Computer.Hardware.Processor.Cores, $report.Computer.Hardware.Processor.Threads, $report.Computer.Hardware.Processor.ClockSpeed)
    Write-Result -Key "Total Memory" -Value ("{0} GB" -f (($report.Computer.Hardware.MemoryModules.Size | Measure-Object -Sum).Sum/1GB))
    $report.Computer.Hardware.MemoryModules | ForEach-Object {
        Write-Result -Key "Module" -Value ("{0} {1}GB {2}Mhz @ {3}Mhz" -f $_.Manufacturer, ($_.Size/1GB), $_.Speed, $_.ConfiguredSpeed)
    }
    $report.Computer.Hardware.Disks | ForEach-Object{
        Write-Result -Key "Disk" -Value ("{0}GB {1} ({2})" -f ($_.Size/1GB), $_.Name, $_.Type)
    }
    $report.Computer.Hardware.NetworkAdapters | ForEach-Object {
        Write-Result -Key $_.Type -Value $_.Name
    }

    Write-Result -Key "Has Camera?" -Value $report.Computer.Hardware.Camera.Present

    Write-Result -Key "Benchmark Score" -Value ("{0}% / CPU: {1} / Gaming CPU: {2}" -f $report.Computer.Benchmark.OverallScore, $report.Computer.Benchmark.CPUSingleCore, $report.Computer.Benchmark.CPUGamingScore)

    Write-Result -Key "OS" -Value $report.Computer.Software.Windows.Version
    Write-Result -Key "Architecture" -Value $report.Computer.Software.Windows.Architecture
    Write-Result -Key "Username" -Value $report.Computer.Software.Windows.User.Name
    Write-Result -Key "Password" -Value $report.Computer.Software.Windows.User.Password
    Write-Result -Key "Account Validated" -Value $report.Computer.Software.Windows.User.CredentialsValidated

    Write-Result -Key "Windows Updates Not Installed" -Value $report.Computer.Software.Windows.Updates.CountRemaining
    $report.Computer.Software.Windows.Updates.InstalledUpdates | ForEach-Object {
        Write-Result -Key "Installed Update" -Value $_.Id
    }

    Write-Result -Key "Windows Activated" -Value $report.Computer.Software.Windows.IsActivated

    Write-Result -Key "Keyboard Test Ok?" -Value $report.Computer.Hardware.Keyboard.TestedOk
    if(![string]::IsNullOrEmpty($report.Computer.Hardware.Keyboard.Notes)){
        Write-Result -Key "Keyboard test notes" -Value $report.Computer.Hardware.Keyboard.Notes    
    }

    Write-Result -Key "Libre Office installed" -Value $report.Computer.Software.LibreOffice.Present
    Write-Result -Key "MSTeams installed" -Value $report.Computer.Software.MSTeams.Present
    Write-Result -Key "Zoom installed" -Value $report.Computer.Software.Zoom.Present
    Write-Result -Key "Edge installed" -Value $report.Computer.Software.Edge.Present

    Write-Result -Key "Desktop background set" -Value $report.Computer.Software.Windows.Desktop.SCHolTechWallPaperSet
    Write-Result -Key "Cursor scheme Black XL" -Value $report.Computer.Software.Windows.Cursor.SchemeSetToBlackXL
    Write-Result -Key "Start Menu Arranged" -Value $report.Computer.Software.Windows.StartMenu.Arranged
    Write-Result -Key "Task View Icon Removed" -Value $report.Computer.Software.Windows.Taskbar.TaskViewRemoved
    Write-Result -Key "Cortana Icon Removed" -Value $report.Computer.Software.Windows.Taskbar.CortanaRemoved
    Write-Result -Key "Search box replaced with icon" -Value $report.Computer.Software.Windows.Taskbar.SearchboxIcon
        
    Write-Result -Key "Icons added to the desktop" -Value $report.Computer.Software.Windows.Desktop.IconsSet
    Write-Result -Key "Set snap to grid off" -Value $report.Computer.Software.Windows.Desktop.SnapToGridOff

    Write-Result -Key "Edge Setup banner dismissed" -Value $report.Computer.Software.Edge.SetupBannerDismissed
    Write-Result -Key "Google set as homepage" -Value $report.Computer.Software.Edge.GoogleAsHomepage
    Write-Result -Key "Google added to favourites" -Value $report.Computer.Software.Edge.AddGoogleToFavourites
    Write-Result -Key "Favourites bar enabled" -Value $report.Computer.Software.Edge.EnableFavouritesBar

    function Write-TrackpadInfo{
        [CmdletBinding()]
        param (
            [Parameter(Mandatory=$true)]
            $Report
        )       
        Write-Result -Key "Gestures disabled" -Value $Report.Computer.Hardware.Trackpad.NoGestures
        Write-Result -Key "Two finger scroll enabled" -Value $Report.Computer.Hardware.Trackpad.TwoFingerScroll
        if(![string]::IsNullOrEmpty($Report.Computer.Hardware.Trackpad.Notes)){
            Write-Result -Key "Trackpad notes" -Value $Report.Computer.Hardware.Trackpad.Notes
        }
    }

    if($report.ReportVersion -eq 2.0){
        Write-TrackpadInfo -Report $report
    } elseif($report.ReportVersion -ge 2.1 -and $Report.Computer.Hardware.Trackpad.Present -eq $true) {
        Write-TrackpadInfo -Report $report
    }
    

    function Write-MouseInfo{
        [CmdletBinding()]
        param (
            [Parameter(Mandatory=$true)]
            $Report
        )       
        if(![string]::IsNullOrEmpty($Report.Computer.Hardware.Mouse.Notes)){
            Write-Result -Key "Mouse notes" -Value $Report.Computer.Hardware.Mouse.Notes
        }
    }

    if($report.ReportVersion -ge 2.1 -and $Report.Computer.Hardware.Mouse.Present -eq $true) {
        Write-MouseInfo -Report $report
    }


    
    Write-Result -Key "Zoom test successful" -Value $report.Computer.Software.Zoom.TestedOK
    if(![string]::IsNullOrEmpty($report.Computer.Software.Zoom.Notes )){
        Write-Result -Key "Zoom test notes" -Value $report.Software.Zoom.Notes 
    }
    
    Write-Result -Key "Camera quality" -Value $report.Computer.Hardware.Camera.Quality
    Write-Result -Key "Mic quality" -Value $report.Computer.Hardware.Microphone.Quality

    Write-Result -Key "Folder over world icon" -Value $report.Computer.Software.Windows.Desktop.FolderOverWorldIcon

    Write-Result -Key "Brightness keys tested successfully" -Value $report.Computer.Hardware.Keyboard.HotKeys.BrightnessKeysWorking
    if(![string]::IsNullOrEmpty($report.Computer.Hardware.Keyboard.HotKeys.Notes)){
        Write-Result -Key "Brightness keys notes" -Value $report.Computer.Hardware.Keyboard.HotKeys.Notes    
    }

    Write-Result -Key "Browser history cleared" -Value $report.Computer.Software.Edge.HistoryCleared
    
    Write-Result -Key "Out of date stickers removed" -Value $report.Computer.OutOfDateStickersRemoved

    Write-Result -Key "SCHol label present on laptop and charger" -Value $report.Computer.SCHolLabelPresent

    Write-Result -Key "Wireless networks removed?" -Value $report.Computer.Software.Windows.WirelessNetworksRemoved

    Write-Result -Key "Battery present?" -Value $report.Computer.Hardware.Battery.Present
    Write-Result -Key "Battery holds charge?" -Value ($report.Computer.Hardware.Battery.ApproximateChargeInMinutes -gt 0)
    Write-Result -Key "Battery charge in minutes?" -Value $report.Computer.Hardware.Battery.ApproximateChargeInMinutes

    Write-Result -Key "Charger tested ok?" -Value $report.Computer.Hardware.Charger.TestedOk

    Write-Result -Key "BIOS Manufacturer" -Value $report.Computer.Hardware.MainBoard.BIOS.Manufacturer
    Write-Result -Key "BIOS Name" -Value $report.Computer.Hardware.MainBoard.BIOS.Name
    Write-Result -Key "BIOS Release Date" -Value $report.Computer.Hardware.MainBoard.BIOS.ReleaseDate
    Write-Result -Key "BIOS Version" -Value $report.Computer.Hardware.MainBoard.BIOS.Version

    Write-Host ""
    Write-Host ""
    Write-Host ""
    Write-Host ""
}
Write-Host "$($MyInvocation.MyCommand.Name) Loaded."