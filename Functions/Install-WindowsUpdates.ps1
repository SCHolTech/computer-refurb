Write-Host "Loading $($MyInvocation.MyCommand.Name)"
function Install-WindowsUpdates {
	[CmdletBinding()]
	param (
		[Parameter()]
		[bool]$RetryEnabled = $true,
		[Parameter()]
		[int]$TryCount = 1
		
	)
	Write-Host "Update attempt $TryCount, RetryEnabled: $RetryEnabled"
	Import-Module PSWindowsUpdate -ErrorAction Stop
    
	try {
		Write-Host "Checking Windows Updates Are All Installed..."
		$updates = Get-WindowsUpdate
		[bool]$allWindowsUpdatesAreInstalled = ($updates.Count -eq 0)

		if(-not $allWindowsUpdatesAreInstalled) {
			Write-Host "Some updates are not installed:"
			$updates | ForEach-Object {
				Write-Host " - $($_.Title)"
			}		
			Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -IgnoreReboot
		} else {
			Write-Host "All updates are installed."
		}
	} catch {
		if($RetryEnabled) {
			Install-WindowsUpdates -TryCount ($TryCount + 1) -RetryEnabled (($TryCount + 1) -lt 5)
		}
	}
}
Write-Host "$($MyInvocation.MyCommand.Name) Loaded."