Write-Host "Loading $($MyInvocation.MyCommand.Name)"
function Test-WindowsUpdatesAreInstalled {  
    Import-Module PSWindowsUpdate
    Write-Host "Checking Windows Updates Are All Installed..."
    $updates = Get-WindowsUpdate
    [bool]$allWindowsUpdatesAreInstalled = ($updates.Count -eq 0)

	if(-not $allWindowsUpdatesAreInstalled) {
        Write-Host "Some updates are not installed:"
        $updates | ForEach-Object {
            Write-Host " - $($_.Title)"
        }
        Start-Process ms-settings:windowsupdate-action
		$response = Read-Host -Prompt "Please install the updates. To bypass this check, type ""a"" before hitting enter"
        if($response.ToLower() -ne "a") {
            Test-WindowsUpdatesAreInstalled
        } else {
            Write-Host "Skipping updates..."
        }	
	} else {
		Write-Host "All updates are installed."
	}
}
Write-Host "$($MyInvocation.MyCommand.Name) Loaded."