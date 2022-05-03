Write-Host "Loading $($MyInvocation.MyCommand.Name)"

. $PSScriptRoot\..\Enums\LanguageOptions.ps1

function Set-LanguageOptions {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        $Report
    )
    
    $option = $null
    while($option -ne [int][LanguageOptions]::EnglishKbdEnglishUI -and `
    $option -ne [int][LanguageOptions]::UkraineKbdEnglishUkraineUI -and `
    $option -ne [int][LanguageOptions]::RussianKbdEnglishUrkraineRussianUI) {
        [LanguageOptions]$option = Read-Host -Prompt "Choose from the following options: `r`n`r`n 1. English Language Pack with English Keyboard `r`n 2. English & Ukrainian Language Packs with Ukrainian (Enhanced) Keyboard `r`n 3. English, Ukrainian and Russian (Ukrainian) Language Packs with Russian keyboard. `r`n`r`n enter 1, 2 or 3"
    }
    $Report.RefurbOptions.LanguageSetup = $option
    return $Report
}
Write-Host "$($MyInvocation.MyCommand.Name) Loaded."