BeforeAll { 
    $functionUnderTest = "$PSScriptRoot\..\Functions\Test-Battery.ps1"
    . $functionUnderTest   
    . $PSScriptRoot\..\Functions\Get-Report.ps1   
}

Describe 'Test-Battery' {
    BeforeEach{
        $report = Get-Report
    }

    Context "Given it is invoked" {
        
        Context "And there is no battery"{
            BeforeEach {
                Mock Read-Host { return "n" } -ParameterFilter { $Prompt -eq "Battery present? (y/n)" }
            }

            It "It records there is no battery " {  
                $report = Test-Battery -Report $report 
                Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Battery present? (y/n)" } -Exactly -Times 1
                Should -ActualValue $report.Computer.Hardware.Battery.Present -ExpectedValue $false -Be
            }
        }

        Context "And there is a battery and it does not hold charge"{
            BeforeEach {
                Mock Read-Host { return "y" } -ParameterFilter { $Prompt -eq "Battery present? (y/n)" }
                Mock Read-Host { return "n" } -ParameterFilter { $Prompt -eq "Holds charge? (y/n)" }
            }

            It "It records the battery as present, holding charge and approx time" {   
                $report = Test-Battery -Report $report
                Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Battery present? (y/n)" } -Exactly -Times 1
                Should -ActualValue $report.Computer.Hardware.Battery.Present -ExpectedValue $true -Be
                Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Holds charge? (y/n)" } -Exactly -Times 1
                Should -ActualValue $report.Computer.Hardware.Battery.ApproximateChargeInMinutes -ExpectedValue 0 -Be
            }
        }

        Context "And there is a battery and it does hold charge"{
            BeforeEach {
                Mock Read-Host { return "y" } -ParameterFilter { $Prompt -eq "Battery present? (y/n)" }
                Mock Read-Host { return "y" } -ParameterFilter { $Prompt -eq "Holds charge? (y/n)" }
                Mock Read-Host { return "60" } -ParameterFilter { $Prompt -eq "Approximate charge in minutes" }
            }

            It "It records the battery as present, holding charge and approx time" {   
                $report = Test-Battery -Report $report
                Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Battery present? (y/n)" } -Exactly -Times 1
                Should -ActualValue $report.Computer.Hardware.Battery.Present -ExpectedValue $true -Be
                Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Holds charge? (y/n)" } -Exactly -Times 1
                Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Approximate charge in minutes" } -Exactly -Times 1
                Should -ActualValue $report.Computer.Hardware.Battery.ApproximateChargeInMinutes -ExpectedValue 60 -Be
            }
        }
    }  
}