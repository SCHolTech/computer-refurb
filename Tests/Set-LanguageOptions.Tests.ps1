BeforeAll { 
    $functionUnderTest = "$PSScriptRoot\..\Functions\Set-LanguageOptions.ps1"
    . $functionUnderTest   
    . $PSScriptRoot\..\Functions\Get-Report.ps1   
}

Describe 'Set-LanguageOptions' {
    BeforeEach{
        $report = Get-Report
    }

    Context "Given it is invoked" {
        
        Context "And english is chosen"{
            BeforeEach {
                Mock Read-Host { return "1" } -ParameterFilter { $Prompt -eq "Choose from the following options: `r`n`r`n 1. English Language Pack with English Keyboard `r`n 2. English & Ukrainian Language Packs with Ukrainian (Enhanced) Keyboard `r`n 3. English, Ukrainian and Russian (Ukrainian) Language Packs with Russian keyboard. `r`n`r`n enter 1, 2 or 3" }
            }

            It "It records that english language with english keyboard has been set" {  
                $report = Set-LanguageOptions -Report $report 
                Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Choose from the following options: `r`n`r`n 1. English Language Pack with English Keyboard `r`n 2. English & Ukrainian Language Packs with Ukrainian (Enhanced) Keyboard `r`n 3. English, Ukrainian and Russian (Ukrainian) Language Packs with Russian keyboard. `r`n`r`n enter 1, 2 or 3" } -Exactly -Times 1
                $actual = [int]($report.RefurbOptions.LanguageSetup)
                $expected = [int][LanguageOptions]::EnglishKbdEnglishUI
                Should -ActualValue $actual -ExpectedValue $expected -Be           
            }
        }

        Context "And english and ukraine with ukraine keyboard is chosen"{
            BeforeEach {
                Mock Read-Host { return "2" } -ParameterFilter { $Prompt -eq "Choose from the following options: `r`n`r`n 1. English Language Pack with English Keyboard `r`n 2. English & Ukrainian Language Packs with Ukrainian (Enhanced) Keyboard `r`n 3. English, Ukrainian and Russian (Ukrainian) Language Packs with Russian keyboard. `r`n`r`n enter 1, 2 or 3" }
            }

            It "It records that english and ukrainian language with english keyboard has been set" {  
                $report = Set-LanguageOptions -Report $report 
                Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Choose from the following options: `r`n`r`n 1. English Language Pack with English Keyboard `r`n 2. English & Ukrainian Language Packs with Ukrainian (Enhanced) Keyboard `r`n 3. English, Ukrainian and Russian (Ukrainian) Language Packs with Russian keyboard. `r`n`r`n enter 1, 2 or 3" } -Exactly -Times 1
                $actual = [int]($report.RefurbOptions.LanguageSetup)
                $expected = [int][LanguageOptions]::UkraineKbdEnglishUkraineUI
                Should -ActualValue $actual -ExpectedValue $expected -Be 
            }
        }

        Context "And english and ukraine and russian with russian keyboard is chosen"{
            BeforeEach {
                Mock Read-Host { return "3" } -ParameterFilter { $Prompt -eq "Choose from the following options: `r`n`r`n 1. English Language Pack with English Keyboard `r`n 2. English & Ukrainian Language Packs with Ukrainian (Enhanced) Keyboard `r`n 3. English, Ukrainian and Russian (Ukrainian) Language Packs with Russian keyboard. `r`n`r`n enter 1, 2 or 3" }
            }

            It "It records that english and ukrainian and russian language with russian keyboard has been set" {  
                $report = Set-LanguageOptions -Report $report 
                Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Choose from the following options: `r`n`r`n 1. English Language Pack with English Keyboard `r`n 2. English & Ukrainian Language Packs with Ukrainian (Enhanced) Keyboard `r`n 3. English, Ukrainian and Russian (Ukrainian) Language Packs with Russian keyboard. `r`n`r`n enter 1, 2 or 3" } -Exactly -Times 1
                $actual = [int]($report.RefurbOptions.LanguageSetup)
                $expected = [int][LanguageOptions]::RussianKbdEnglishUrkraineRussianUI
                Should -ActualValue $actual -ExpectedValue $expected -Be 
            }
        }
    }  
}