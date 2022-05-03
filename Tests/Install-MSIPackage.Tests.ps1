BeforeAll { 
    $functionUnderTest = "$PSScriptRoot\..\Functions\Install-MSIPackage.ps1"
    . $functionUnderTest    
}

Describe 'Install-MSIPackage' {
    BeforeEach{
        
        Mock Start-Process {} -ParameterFilter { $FilePath -eq "msiexec" -and $ArgumentList -eq "-someargument"}
        Mock Write-Host {} -ParameterFilter { $Object -eq "Installing some package..."}


    }
    Context "Given it is invoked" {
                
        It "It prints the runs the installer with the specified arguments" { 
            Install-MSIPackage -Arguments "-someargument" -PackageName "some package"   
            Should -Invoke -CommandName Write-Host -ParameterFilter { $Object -eq "Installing some package..." } -Exactly -Times 1
        }

        It "It runs the installer with the specified arguments" {
            Install-MSIPackage -Arguments "-someargument" -PackageName "some package"
            Should -Invoke -CommandName Start-Process -ParameterFilter { $ArgumentList -eq "-someargument" } -Exactly -Times 1
        }

        It "It tests the installer exists if testpath is present and returns true when found" {
            Mock Test-Path {return $true} -ParameterFilter { $Path -eq "C:\foo\bar" }
            $installed = Install-MSIPackage -Arguments "-someargument" -PackageName "some package" -TestPath "C:\foo\bar"
            Should -ActualValue $installed -Be -ExpectedValue $true
            Should -Invoke -CommandName Test-Path -Exactly -Times 1
        }

        It "It tests the installer exists if testpath is present and returns false when not found" {
            Mock Test-Path {return $false} -ParameterFilter { $Path -eq "C:\foo\bar" }
            $installed = Install-MSIPackage -Arguments "-someargument" -PackageName "some package" -TestPath "C:\foo\bar"
            Should -ActualValue $installed -Be -ExpectedValue $false
            Should -Invoke -CommandName Test-Path -Exactly -Times 1
        }

        It "Does not test the installer exists if testpath does not exist" {
            Mock Test-Path
            $installed = Install-MSIPackage -Arguments "-someargument" -PackageName "some package"
            Should -ActualValue $installed -Be -ExpectedValue $null
            Should -Invoke -CommandName Test-Path -Exactly -Times 0
        }
    }
}