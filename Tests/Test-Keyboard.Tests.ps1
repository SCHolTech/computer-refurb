BeforeAll { 
    $functionUnderTest = "$PSScriptRoot\..\Functions\Test-Keyboard.ps1"
    . $functionUnderTest   
    . $PSScriptRoot\..\Functions\Get-Report.ps1   
}

Describe 'Test-Keyboard' {
    BeforeEach{
        
        Mock Start-Process {}
        Mock Read-Host { return "y" } -ParameterFilter { $Prompt -eq "Did the keyboard test pass? (y/n)" }
        $report = Get-Report

    }
    Context "Given it is invoked" {
        
        It "It opens the keyboard tester" {
            $report = Test-Keyboard -Report $report
            Should -Invoke -CommandName Start-Process -ParameterFilter { $FilePath -eq "https://keyboardtester.co/keyboard-tester" } -Exactly -Times 1
        }
        Context "And the keyboard test is successful"{
            BeforeEach {
                Mock Read-Host { return "y" } -ParameterFilter { $Prompt -eq "Did the keyboard test pass? (y/n)" }
                $report = Test-Keyboard -Report $report
            }

            It "It records the keyboard test as successful" {   
                Should -Invoke -CommandName Read-Host -Exactly -Times 1
                Should -ActualValue $report.Computer.Hardware.Keyboard.TestedOk -ExpectedValue $true -Be
            }
        }

        Context "And the keyboard test is not successful"{
            BeforeEach {
                Mock Read-Host { return "n" } -ParameterFilter { $Prompt -eq "Did the keyboard test pass? (y/n)" }
                Mock Read-Host { return "It did not work" } -ParameterFilter { $Prompt -eq "Notes on keyboard failure" }
                $report = Test-Keyboard -Report $report
            }

            It "It records the keyboard test as not successful and the users notes" {   
                Should -Invoke -CommandName Read-Host -Exactly -Times 2
                Should -ActualValue $report.Computer.Hardware.Keyboard.TestedOk -ExpectedValue $false -Be
                Should -ActualValue $report.Computer.Hardware.Keyboard.Notes -ExpectedValue "It did not work" -Be
            }
        }
    }  
}