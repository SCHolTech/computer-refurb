BeforeAll { 
    $functionUnderTest = "$PSScriptRoot\..\Functions\Test-Speakers.ps1"
    . $functionUnderTest   
    . $PSScriptRoot\..\Functions\Get-Report.ps1   
}

Describe 'Test-Speakers' {
    BeforeEach{
        
        Mock Start-Process {}
        Mock Read-Host { return "n" } -ParameterFilter { $Prompt -eq "Are speakers present? (y/n)" }
        $report = Get-Report
    }
    Context "Given it is invoked" {
        
        It "It prompts if speakers present and if not records the result" {
            $report = Test-Speakers -Report $report
            Should -Invoke -CommandName Read-Host -Exactly -Times 1
            Should -ActualValue $report.Computer.Hardware.Speakers.Present -ExpectedValue $false -Be
        }

        Context "Speakers are present" {
            BeforeEach {
                Mock Read-Host { return "y" } -ParameterFilter { $Prompt -eq "Did the speaker test pass? (y/n)" }
                Mock Read-Host { return "y" } -ParameterFilter { $Prompt -eq "Are speakers present? (y/n)" }
            }

            It "It prompts if speakers present and if not records the result" {
                $report = Test-Speakers -Report $report
                Should -Invoke -CommandName Read-Host -Exactly -Times 2
                Should -ActualValue $report.Computer.Hardware.Speakers.Present -ExpectedValue $true -Be
            }

            It "It opens the speaker tester" {
                $report = Test-Speakers -Report $report
                Should -Invoke -CommandName Start-Process -ParameterFilter { $FilePath -eq "https://www.youtube.com/watch?v=2ZrWHtvSog4" } -Exactly -Times 1
            }
            Context "And the speaker test is successful"{
                BeforeEach {
                    Mock Read-Host { return "y" } -ParameterFilter { $Prompt -eq "Did the speaker test pass? (y/n)" }
                    $report = Test-Speakers -Report $report
                }

                It "It records the speaker test as successful" {   
                    Should -Invoke -CommandName Read-Host -Exactly -Times 2
                    Should -ActualValue $report.Computer.Hardware.Speakers.TestedOk -ExpectedValue $true -Be
                }
            }

            Context "And the speaker test is not successful"{
                BeforeEach {
                    Mock Read-Host { return "n" } -ParameterFilter { $Prompt -eq "Did the speaker test pass? (y/n)" }
                    Mock Read-Host { return "It did not work" } -ParameterFilter { $Prompt -eq "Notes on speaker failure" }
                    $report = Test-Speakers -Report $report
                }

                It "It records the speaker test as not successful and the users notes" {   
                    Should -Invoke -CommandName Read-Host -Exactly -Times 3
                    Should -ActualValue $report.Computer.Hardware.Speakers.TestedOk -ExpectedValue $false -Be
                    Should -ActualValue $report.Computer.Hardware.Speakers.Notes -ExpectedValue "It did not work" -Be
                }
            }
        }
    }  
}