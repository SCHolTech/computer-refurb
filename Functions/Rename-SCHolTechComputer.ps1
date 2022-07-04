Write-Host "Loading $($MyInvocation.MyCommand.Name)"
function Rename-SCHolTechComputer {
	$computerName = $env:computername;
	if(-not $computerName.StartsWith("SCHOL-T")){
		Write-Host "Computer needs renaming!"
		[int]$computerId = Read-Host -Prompt "Please enter the computer ID. e.g. if the T number is T68, enter 68"
		$newComputerName = "SCHOL-T$computerId"
		$ok = Read-Host -Prompt "The computer name will be set to $newComputerName. Hit y to continue"
		if($ok.ToLower() -eq "y") {
			Rename-Computer -NewName $newComputerName
		} else {
			Rename-SCHolTechComputer
		}
	}
}

Write-Host "$($MyInvocation.MyCommand.Name) Loaded."