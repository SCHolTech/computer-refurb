Write-Host "Loading $($MyInvocation.MyCommand.Name)"
function Write-Result{
    param (
        $Key,
        $Value
    )
    if($Value -eq $true){
        $Value = "Yes"
    } elseif ($Value -eq $false){
        $Value = "No"
    }
    $Key = $Key.PadLeft(35, " ")
    Write-Host ("{0} : {1}" -f $Key, $Value)
}
Write-Host "$($MyInvocation.MyCommand.Name) Loaded."