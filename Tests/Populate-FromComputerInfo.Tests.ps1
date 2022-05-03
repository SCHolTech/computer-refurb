BeforeAll { 
    $functionUnderTest = "$PSScriptRoot\..\Functions\Populate-FromComputerInfo.ps1"
    . $functionUnderTest    
    . $PSScriptRoot\..\Functions\Get-Report.ps1
}

Describe 'Populate-FromComputerInfo' {
    BeforeEach{        
        $report = Get-Report
    }
    Context "Given it is invoked" {           
        It "Populates the report with no errors" { 
            $report = Populate-FromComputerInfo -Report $report
        }
    }
}