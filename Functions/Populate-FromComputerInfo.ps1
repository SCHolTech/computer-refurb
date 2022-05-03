Write-Host "Loading $($MyInvocation.MyCommand.Name)"
function Populate-FromComputerInfo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        $Report
    ) 
    
    $computerInfo = Get-ComputerInfo

    $Report.Computer.Manufacturer = $computerInfo.CsManufacturer
    $Report.Computer.Model = $computerInfo.CsModel

    $Report.Computer.Hardware.Processor.Manufacturer = $computerInfo.CsProcessors[0].Manufacturer
    $Report.Computer.Hardware.Processor.Model = $computerInfo.CsProcessors[0].Name
    $Report.Computer.Hardware.Processor.Cores = $computerInfo.CsProcessors[0].NumberOfCores
    $Report.Computer.Hardware.Processor.Threads = $computerInfo.CsProcessors[0].NumberOfLogicalProcessors
    $Report.Computer.Hardware.Processor.Architecture = $computerInfo.CsProcessors[0].Architecture
    $Report.Computer.Hardware.Processor.ClockSpeed = $computerInfo.CsProcessors[0].MaxClockSpeed

    $Report.Computer.Hardware.MainBoard.BIOS.Manufacturer = $computerInfo.BiosManufacturer
    $Report.Computer.Hardware.MainBoard.BIOS.Name = $computerInfo.BiosName
    $Report.Computer.Hardware.MainBoard.BIOS.ReleaseDate = $computerInfo.BiosReleaseDate
    $Report.Computer.Hardware.MainBoard.BIOS.Version = $computerInfo.BiosVersion

    $Report.Computer.Software.Windows.Updates.InstalledUpdates = @()
    $computerInfo.OsHotFixes | ForEach-Object {
        $Report.Computer.Software.Windows.Updates.InstalledUpdates += @{
            Id = $_.HotFixID
            Description = $_.Description
        }
    }

    $Report.Computer.Software.Windows.Architecture = $computerInfo.OsArchitecture
    $Report.Computer.Software.Windows.Version = "{0} - {1}" -f $computerInfo.WindowsProductName, $computerInfo.WindowsVersion
    

    $memory = Get-WmiObject win32_physicalmemory
    $report.Computer.Hardware.MemoryModules = @()
    $memory | ForEach-Object { 
        $report.Computer.Hardware.MemoryModules += @{
            Size = $_.Capacity
            Speed = $_.Speed
            ConfiguredSpeed = $_.ConfiguredClockSpeed
            Manufacturer = $_.Manufacturer
        }
    }

    $report.Computer.Hardware.Disks = @()
    Get-PhysicalDisk | ForEach-Object {
        $report.Computer.Hardware.Disks += @{
           Name = $_.FriendlyName
           Type = $_.MediaType
           Size = $_.Size
           SerialNumber = $_.SerialNumber
        }
    }
   
    $report.Computer.Hardware.NetworkAdapters = @()
    Get-NetAdapter | Where-Object { $_.PhysicalMediaType -match "802.11" -or $_.PhysicalMediaType -match "Wireless" } | ForEach-Object {
        $report.Computer.Hardware.NetworkAdapters += @{
            Type = "Wifi"
            Name = $_.InterfaceDescription
        }
    }
    Get-NetAdapter | Where-Object { $_.PhysicalMediaType -match "802.3" } | ForEach-Object {
       $report.Computer.Hardware.NetworkAdapters += @{
           Type = "Ethernet"
           Name = $_.InterfaceDescription
       }
   }

   try {
        $report.Computer.Hardware.Mainboard.BIOS.SecureBootEnabled = (Confirm-SecureBootUEFI -ErrorAction SilentlyContinue)
        $report.Computer.Hardware.Mainboard.BIOS.UEFI = $true
    } catch{
        $report.Computer.Hardware.Mainboard.BIOS.SecureBootEnabled = $false
        $report.Computer.Hardware.Mainboard.BIOS.UEFI = $false
    }

    $tpm = Get-Tpm
    if($tpm.TpmPresent -eq $true){
        $report.Computer.Hardware.Mainboard.TPM.Present = $tpm.TpmPresent
        if($report.Computer.Hardware.Mainboard.TPM.Present){
            $tpmDetails = Get-WmiObject -Namespace 'root\cimv2\security\microsofttpm' -Query "Select * from win32_tpm"
            $report.Computer.Hardware.Mainboard.TPM.Version = ($tpmDetails.SpecVersion.Split(",") | Select-Object -First 1).ToString()
        }
    }
    
    $report.Computer.Software.Windows.ComputerName = $env:COMPUTERNAME
    $report.Computer.SCHolTechNumber = $report.Computer.Software.Windows.ComputerName.Replace("SCHOL-", "")

    $report.Computer.Software.Windows.User.Name = $env:USERNAME


    return $Report
}

Write-Host "$($MyInvocation.MyCommand.Name) Loaded."