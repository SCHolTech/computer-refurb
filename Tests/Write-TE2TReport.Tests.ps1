BeforeAll { 
    $functionUnderTest = "$PSScriptRoot\..\Functions\Write-TE2TReport.ps1"
    . $functionUnderTest    
    . $PSScriptRoot\..\Functions\Get-Report.ps1
    . $PSScriptRoot\..\Functions\Populate-FromComputerInfo.ps1
}

Describe 'Write-TE2TReport' {
    BeforeEach{        
        $report = Get-Report
        $report = Populate-FromComputerInfo -Report $report

    }
    Context "Given it is invoked" {           
        It "Populates the report with no errors" { 
            Write-TE2TReport -Report $report
        }
    }
}