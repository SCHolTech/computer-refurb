Write-Host "Loading $($MyInvocation.MyCommand.Name)"

. $PSScriptRoot\..\Enums\LanguageOptions.ps1

function Set-LanguageSwitches {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [LanguageOptions]
        $LanguageOption
    )

    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force -ErrorAction SilentlyContinue

    if($LanguageOption -eq  [LanguageOptions]::UkraineKbdEnglishUkraineUI){
        Copy-Item $PSScriptRoot\..\Assets\LanguageSwitches\UkraineKbdEnglishUkraineUI -Destination "C:\LanguageSwitches" -Recurse    
    }

    if($LanguageOption -eq  [LanguageOptions]::RussianKbdEnglishUrkraineRussianUI){
        Copy-Item $PSScriptRoot\..\Assets\LanguageSwitches\RussianKbdEnglishUkraineRussianUI -Destination "C:\LanguageSwitches" -Recurse    
    }

    Get-ChildItem "C:\LanguageSwitches\*.lnk" -Recurse | ForEach-Object {
        Copy-Item $_.FullName -Destination "$($env:PUBLIC)\Desktop\$($_.Name)"
    }
}
Write-Host "$($MyInvocation.MyCommand.Name) Loaded."