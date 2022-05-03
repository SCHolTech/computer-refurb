BeforeAll { 
    $functionUnderTest = "$PSScriptRoot\..\Functions\Test-HotKeys.ps1"
    . $functionUnderTest   
    . $PSScriptRoot\..\Functions\Get-Report.ps1   
}

Describe 'Test-HotKeys' {
    BeforeEach{   
        $report = Get-Report
    }

    Context "Given it is invoked" {
        
        Context "And there are no brightness keys"{
            BeforeEach {
                Mock Read-Host { return "n" } -ParameterFilter { $Prompt -eq "Are there brightness hotkeys? (y/n)" }
                Mock Read-Host { return "n" } -ParameterFilter { $Prompt -eq "Are there volume hotkeys? (y/n)" }
            }

            It "It records the brightness keys as not present" {  
                $report = Test-Hotkeys -Report $report 
                Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Are there brightness hotkeys? (y/n)" } -Exactly -Times 1
                Should -ActualValue $report.Computer.Hardware.Keyboard.HotKeys.BrightnessKeysPresent -ExpectedValue $false -Be
            }
        }

        Context "And there are brightness keys and they work"{
            BeforeEach {
                Mock Read-Host { return "y" } -ParameterFilter { $Prompt -eq "Are there brightness hotkeys? (y/n)" }
                Mock Read-Host { return "y" } -ParameterFilter { $Prompt -eq "Do the brightness keys work? (y/n)" }
                Mock Read-Host { return "n" } -ParameterFilter { $Prompt -eq "Are there volume hotkeys? (y/n)" }
            }

            It "It records the brightness keys as present and working" {   
                $report = Test-Hotkeys -Report $report
                Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Are there brightness hotkeys? (y/n)" } -Exactly -Times 1
                Should -ActualValue $report.Computer.Hardware.Keyboard.HotKeys.BrightnessKeysPresent -ExpectedValue $true -Be
                Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Do the brightness keys work? (y/n)" } -Exactly -Times 1
                Should -ActualValue $report.Computer.Hardware.Keyboard.HotKeys.BrightnessKeysWorking -ExpectedValue $true -Be
            }
        }

        Context "And there are brightness keys and they don't work"{
            BeforeEach {
                Mock Read-Host { return "y" } -ParameterFilter { $Prompt -eq "Are there brightness hotkeys? (y/n)" }
                Mock Read-Host { return "n" } -ParameterFilter { $Prompt -eq "Do the brightness keys work? (y/n)" }
                Mock Read-Host { return "Brightness driver missing" } -ParameterFilter { $Prompt -eq "Enter any hotkey notes" }
                Mock Read-Host { return "n" } -ParameterFilter { $Prompt -eq "Are there volume hotkeys? (y/n)" }
            }

            It "It records the brightness keys as present and not working" {   
                $report = Test-Hotkeys -Report $report
                Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Are there brightness hotkeys? (y/n)" } -Exactly -Times 1
                Should -ActualValue $report.Computer.Hardware.Keyboard.HotKeys.BrightnessKeysPresent -ExpectedValue $true -Be
                Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Do the brightness keys work? (y/n)" } -Exactly -Times 1
                Should -ActualValue $report.Computer.Hardware.Keyboard.HotKeys.BrightnessKeysWorking -ExpectedValue $false -Be
                Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Enter any hotkey notes" } -Exactly -Times 1
                Should -ActualValue $report.Computer.Hardware.Keyboard.HotKeys.Notes -ExpectedValue "Brightness driver missing" -Be
            }
        }

        Context "And there are no volume keys"{
            BeforeEach {
                Mock Read-Host { return "n" } -ParameterFilter { $Prompt -eq "Are there brightness hotkeys? (y/n)" }
                Mock Read-Host { return "n" } -ParameterFilter { $Prompt -eq "Are there volume hotkeys? (y/n)" }
            }

            It "It records the volume keys as not present" {  
                $report = Test-Hotkeys -Report $report 
                Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Are there volume hotkeys? (y/n)" } -Exactly -Times 1
                Should -ActualValue $report.Computer.Hardware.Keyboard.HotKeys.VolumeKeysPresent -ExpectedValue $false -Be
            }
        }

        Context "And there are volume keys and they work"{
            BeforeEach {
                Mock Read-Host { return "n" } -ParameterFilter { $Prompt -eq "Are there brightness hotkeys? (y/n)" }
                Mock Read-Host { return "y" } -ParameterFilter { $Prompt -eq "Are there volume hotkeys? (y/n)" }
                Mock Read-Host { return "y" } -ParameterFilter { $Prompt -eq "Do the volume keys work? (y/n)" }
            }

            It "It records the volume keys as present and working" {   
                $report = Test-Hotkeys -Report $report
                Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Are there volume hotkeys? (y/n)" } -Exactly -Times 1
                Should -ActualValue $report.Computer.Hardware.Keyboard.HotKeys.VolumeKeysPresent -ExpectedValue $true -Be
                Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Do the volume keys work? (y/n)" } -Exactly -Times 1
                Should -ActualValue $report.Computer.Hardware.Keyboard.HotKeys.VolumeKeysWorking -ExpectedValue $true -Be
            }
        }

        Context "And there are volume keys and they don't work"{
            BeforeEach {
                Mock Read-Host { return "n" } -ParameterFilter { $Prompt -eq "Are there brightness hotkeys? (y/n)" }
                Mock Read-Host { return "y" } -ParameterFilter { $Prompt -eq "Are there volume hotkeys? (y/n)" }
                Mock Read-Host { return "n" } -ParameterFilter { $Prompt -eq "Do the volume keys work? (y/n)" }
                Mock Read-Host { return "Volume driver missing" } -ParameterFilter { $Prompt -eq "Enter any hotkey notes" }
            }

            It "It records the volume keys as present and not working" {   
                $report = Test-Hotkeys -Report $report
                Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Are there volume hotkeys? (y/n)" } -Exactly -Times 1
                Should -ActualValue $report.Computer.Hardware.Keyboard.HotKeys.VolumeKeysPresent -ExpectedValue $true -Be
                Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Do the volume keys work? (y/n)" } -Exactly -Times 1
                Should -ActualValue $report.Computer.Hardware.Keyboard.HotKeys.VolumeKeysWorking -ExpectedValue $false -Be
                Should -Invoke -CommandName Read-Host -ParameterFilter { $Prompt -eq "Enter any hotkey notes" } -Exactly -Times 1
                Should -ActualValue $report.Computer.Hardware.Keyboard.HotKeys.Notes -ExpectedValue "Volume driver missing" -Be
            }
        }
    }  
}