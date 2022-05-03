BeforeAll { 
    $functionUnderTest = "$PSScriptRoot\..\Functions\Test-Trackpad.ps1"
    . $functionUnderTest   
    . $PSScriptRoot\..\Functions\Get-Report.ps1   
}

Describe 'Test-Trackpad' {
    BeforeEach{
        Mock Start-Process { } -ParameterFilter { $FilePath -eq "main.cpl" }
        Mock Start-Process { } -ParameterFilter { $FilePath -eq "ms-settings:devices-touchpad" }
        Mock Read-Host {} -ParameterFilter { $Prompt -eq "Configure the trackpad and hit any key to continue" }
        Mock Read-Host { return "y" } -ParameterFilter { $Prompt -eq "Does the left trackpad button work? (y/n)" }
        Mock Read-Host { return "y" } -ParameterFilter { $Prompt -eq "Does the right trackpad button work? (y/n)" }
        Mock Read-Host { return "y" } -ParameterFilter { $Prompt -eq "Does 2-finger scroll work? (y/n)" }
        Mock Read-Host { return "y" } -ParameterFilter { $Prompt -eq "Are 3 and 4 finger tap and flick turned off? (y/n)" }
        Mock Read-Host { return "n" } -ParameterFilter { $Prompt -eq "Is there a trackpad? (y/n)" }
        $report = Get-Report

    }
    Context "Given it is invoked" {

        It "It prompts if trackpad is present and if not records the result" {
            $report = Test-Trackpad -Report $report
            Should -Invoke -CommandName Read-Host -Exactly -Times 1
            Should -ActualValue $report.Computer.Hardware.Trackpad.Present -ExpectedValue $false -Be
        }

        Context "Trackpad is present" {

            BeforeEach{
                Mock Read-Host { return "y" } -ParameterFilter { $Prompt -eq "Is there a trackpad? (y/n)" }
            }



            It "opens the control panel mouse dialogue"{
                $report = Test-Trackpad -Report $report
                Should -Invoke -CommandName Start-Process -ParameterFilter { $FilePath -eq "main.cpl" } -Exactly -Times 1
            }

            It "opens the touchpag settings dialogue" {
                $report = Test-Trackpad -Report $report
                Should -Invoke -CommandName Start-Process -ParameterFilter { $FilePath -eq "ms-settings:devices-touchpad" } -Exactly -Times 1
            }

            It "Prompts for a check of left click" {
                $report = Test-Trackpad -Report $report
                Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Does the left trackpad button work? (y/n)" } -Exactly -Times 1
            }  

            It "Prompts for a check of right click" {
                $report = Test-Trackpad -Report $report
                Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Does the right trackpad button work? (y/n)" } -Exactly -Times 1
            }  

            It "Prompts for a check of 2-finger scroll" {
                $report = Test-Trackpad -Report $report
                Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Does 2-finger scroll work? (y/n)" } -Exactly -Times 1
            } 

            It "Prompts to check gestures are turned off" {
                $report = Test-Trackpad -Report $report
                Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Are 3 and 4 finger tap and flick turned off? (y/n)" } -Exactly -Times 1
            } 

            Context "And the left click is successful" {
                    It "records the leftclick result" {
                    $report = Test-Trackpad -Report $report
                    Should -Be -ActualValue $report.Computer.Hardware.Trackpad.LeftClickOk -ExpectedValue $true
                }  
            }

            Context "And the right click is successful" {
                    It "records the rightclick result" {
                    $report = Test-Trackpad -Report $report
                    Should -Be -ActualValue $report.Computer.Hardware.Trackpad.RightClickOk -ExpectedValue $true
                }  
            }

            Context "And the 2-finger scroll is successful" {
                It "records the 2-finger scroll result" {
                    $report = Test-Trackpad -Report $report
                    Should -Be -ActualValue $report.Computer.Hardware.Trackpad.TwoFingerScroll -ExpectedValue $true
                }  
            }

            Context "And gestures are turned off successful" {
                It "records the gestures off result" {
                    $report = Test-Trackpad -Report $report
                    Should -Be -ActualValue $report.Computer.Hardware.Trackpad.NoGestures -ExpectedValue $true
                }  
            }

            Context "And the left click is not successful" {
                BeforeEach {
                    Mock Read-Host { return "n" } -ParameterFilter { $Prompt -eq "Does the left trackpad button work? (y/n)" }
                    Mock Read-Host { return "Left click didn't work" } -ParameterFilter { $Prompt -eq "Please add any trackpad notes" }
                    $report = Test-Trackpad -Report $report
                }

                It "it records the result" {
                    Should -Be -ActualValue $report.Computer.Hardware.Trackpad.LeftClickOk -ExpectedValue $false
                }  

                It "it prompts for notes and records them" {
                    Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Please add any trackpad notes" } -Exactly -Times 1
                    Should -Be -ActualValue $report.Computer.Hardware.Trackpad.Notes -ExpectedValue "Left click didn't work"
                }  
            }

            Context "And the right click is not successful" {
                BeforeEach {
                    Mock Read-Host { return "n" } -ParameterFilter { $Prompt -eq "Does the right trackpad button work? (y/n)" }
                    Mock Read-Host { return "Right click didn't work" } -ParameterFilter { $Prompt -eq "Please add any trackpad notes" }
                    $report = Test-Trackpad -Report $report
                }

                It "it records the result" {
                    Should -Be -ActualValue $report.Computer.Hardware.Trackpad.RightClickOk -ExpectedValue $false
                }  

                It "it prompts for notes and records them" {
                    Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Please add any trackpad notes" } -Exactly -Times 1
                    Should -Be -ActualValue $report.Computer.Hardware.Trackpad.Notes -ExpectedValue "Right click didn't work"
                }  
            } 
            
            Context "And the 2-finger scroll is not successful" {
                BeforeEach {
                    Mock Read-Host { return "n" } -ParameterFilter { $Prompt -eq "Does 2-finger scroll work? (y/n)" }
                    Mock Read-Host { return "2-finger scroll didn't work" } -ParameterFilter { $Prompt -eq "Please add any trackpad notes" }
                    $report = Test-Trackpad -Report $report
                }

                It "it records the result" {
                    Should -Be -ActualValue $report.Computer.Hardware.Trackpad.TwoFingerScroll -ExpectedValue $false
                }  

                It "it prompts for notes and records them" {
                    
                    Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Please add any trackpad notes" } -Exactly -Times 1
                    Should -Be -ActualValue $report.Computer.Hardware.Trackpad.Notes -ExpectedValue "2-finger scroll didn't work"
                }  
            }  

            Context "And the gestures are not successful" {
                BeforeEach {
                    Mock Read-Host { return "n" } -ParameterFilter { $Prompt -eq "Are 3 and 4 finger tap and flick turned off? (y/n)" }
                    Mock Read-Host { return "can't disable gestures" } -ParameterFilter { $Prompt -eq "Please add any trackpad notes" }
                    $report = Test-Trackpad -Report $report
                }

                It "it records the result" {
                    Should -Be -ActualValue $report.Computer.Hardware.Trackpad.NoGestures -ExpectedValue $false
                }  

                It "it prompts for notes and records them" {
                    Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Please add any trackpad notes" } -Exactly -Times 1
                    Should -Be -ActualValue $report.Computer.Hardware.Trackpad.Notes -ExpectedValue "can't disable gestures"
                }  
            } 
        }
    }
}
