Write-Host "Loading $($MyInvocation.MyCommand.Name)"
function Test-WindowsIsActivated {
    Write-Host "Checking Windows Activation Status..."
	[bool]$windowsIsActivated = ((Get-CimInstance SoftwareLicensingProduct -Filter "Name like 'Windows%'" | Where-Object { $_.PartialProductKey }).LicenseStatus -eq 1)
	if(-not $windowsIsActivated) {
        Start-Process ms-settings:activation
		$response = Read-Host -Prompt "Please activate Windows before continuing. Hit enter when ready. To bypass this check, type ""a"" at the command prompt"
        if($response.ToLower() -ne "a") {
            Test-WindowsIsActivated
        } else {
            Write-Host "Skipping Activation..."
        }	
	} else {
		Write-Host "Windows is activated"
	}
}
Write-Host "$($MyInvocation.MyCommand.Name) Loaded."