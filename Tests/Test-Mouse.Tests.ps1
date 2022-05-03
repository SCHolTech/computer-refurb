BeforeAll { 
    $functionUnderTest = "$PSScriptRoot\..\Functions\Test-Mouse.ps1"
    . $functionUnderTest   
    . $PSScriptRoot\..\Functions\Get-Report.ps1   
}

Describe 'Test-Mouse' {
    BeforeEach{
        Mock Read-Host { return "y" } -ParameterFilter { $Prompt -eq "Does the left mouse button work? (y/n)" }
        Mock Read-Host { return "y" } -ParameterFilter { $Prompt -eq "Does the right mouse button work? (y/n)" }
        Mock Read-Host { return "y" } -ParameterFilter { $Prompt -eq "Does the scroll wheel work? (y/n)" }
        Mock Read-Host { return "n" } -ParameterFilter { $Prompt -eq "Is there a mouse? (y/n)" }
        $report = Get-Report

    }
    Context "Given it is invoked" {

        It "It prompts if mouse is present and if not records the result" {
            $report = Test-Mouse -Report $report
            Should -Invoke -CommandName Read-Host -Exactly -Times 1
            Should -ActualValue $report.Computer.Hardware.Mouse.Present -ExpectedValue $false -Be
        }

        Context "Mouse is present" {

            BeforeEach{
                Mock Read-Host { return "y" } -ParameterFilter { $Prompt -eq "Is there a mouse? (y/n)" }
            }

            It "Prompts for a check of left click" {
                $report = Test-Mouse -Report $report
                Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Does the left mouse button work? (y/n)" } -Exactly -Times 1
            }  

            It "Prompts for a check of right click" {
                $report = Test-Mouse -Report $report
                Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Does the right mouse button work? (y/n)" } -Exactly -Times 1
            }  

            It "Prompts for a check of 2-finger scroll" {
                $report = Test-Mouse -Report $report
                Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Does the scroll wheel work? (y/n)" } -Exactly -Times 1
            } 

            Context "And the left click is successful" {
                    It "records the leftclick result" {
                    $report = Test-Mouse -Report $report
                    Should -Be -ActualValue $report.Computer.Hardware.Mouse.LeftClickOk -ExpectedValue $true
                }  
            }

            Context "And the right click is successful" {
                    It "records the rightclick result" {
                    $report = Test-Mouse -Report $report
                    Should -Be -ActualValue $report.Computer.Hardware.Mouse.RightClickOk -ExpectedValue $true
                }  
            }

            Context "And the scroll wheel is successful" {
                It "records the scroll wheel result" {
                    $report = Test-Mouse -Report $report
                    Should -Be -ActualValue $report.Computer.Hardware.Mouse.ScrollWheelOk -ExpectedValue $true
                }  
            }

            Context "And the left click is not successful" {
                BeforeEach {
                    Mock Read-Host { return "n" } -ParameterFilter { $Prompt -eq "Does the left mouse button work? (y/n)" }
                    Mock Read-Host { return "Left click didn't work" } -ParameterFilter { $Prompt -eq "Please add any mouse notes" }
                    $report = Test-Mouse -Report $report
                }

                It "it records the result" {
                    Should -Be -ActualValue $report.Computer.Hardware.Mouse.LeftClickOk -ExpectedValue $false
                }  

                It "it prompts for notes and records them" {
                    Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Please add any mouse notes" } -Exactly -Times 1
                    Should -Be -ActualValue $report.Computer.Hardware.Mouse.Notes -ExpectedValue "Left click didn't work"
                }  
            }

            Context "And the right click is not successful" {
                BeforeEach {
                    Mock Read-Host { return "n" } -ParameterFilter { $Prompt -eq "Does the right mouse button work? (y/n)" }
                    Mock Read-Host { return "Right click didn't work" } -ParameterFilter { $Prompt -eq "Please add any mouse notes" }
                    $report = Test-Mouse -Report $report
                }

                It "it records the result" {
                    Should -Be -ActualValue $report.Computer.Hardware.Mouse.RightClickOk -ExpectedValue $false
                }  

                It "it prompts for notes and records them" {
                    Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Please add any mouse notes" } -Exactly -Times 1
                    Should -Be -ActualValue $report.Computer.Hardware.Mouse.Notes -ExpectedValue "Right click didn't work"
                }  
            } 
            
            Context "And the scroll wheel is not successful" {
                BeforeEach {
                    Mock Read-Host { return "n" } -ParameterFilter { $Prompt -eq "Does the scroll wheel work? (y/n)" }
                    Mock Read-Host { return "scroll wheel didn't work" } -ParameterFilter { $Prompt -eq "Please add any mouse notes" }
                    $report = Test-Mouse -Report $report
                }

                It "it records the result" {
                    Should -Be -ActualValue $report.Computer.Hardware.Mouse.ScrollWheelOk -ExpectedValue $false
                }  

                It "it prompts for notes and records them" {
                    
                    Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Please add any mouse notes" } -Exactly -Times 1
                    Should -Be -ActualValue $report.Computer.Hardware.Mouse.Notes -ExpectedValue "scroll wheel didn't work"
                }  
            }  
        }
    }
}
