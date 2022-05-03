BeforeAll { 
    $functionUnderTest = "$PSScriptRoot\..\Functions\Write-Report.ps1"
    . $functionUnderTest    
    . $PSScriptRoot\..\Functions\Get-Report.ps1
    . $PSScriptRoot\..\Functions\Populate-FromComputerInfo.ps1
}

Describe 'Write-Report' {
    BeforeEach{        
        $report = Get-Report
        $report = Populate-FromComputerInfo -Report $report
    }
    Context "Given it is invoked" {           
        It "Populates the report with no errors" { 
            Write-Report -Report $report
        }
    }
}