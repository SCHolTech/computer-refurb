Write-Host "Loading $($MyInvocation.MyCommand.Name)"
function Test-HDVideoPlayback {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        $Report
    )   

    Start-Process microsoft-edge:https://www.youtube.com/watch?v=XVkADAwOXnU

    $Report.Computer.Benchmark.HDVideoPlayback = (Read-Host -Prompt "Did the video play at 1080p with less that 10% frame drop? (y/n)").ToLower() -eq "y"    
    return $Report
}

Write-Host "$($MyInvocation.MyCommand.Name) Loaded."