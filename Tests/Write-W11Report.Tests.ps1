BeforeAll { 
    $functionUnderTest = "$PSScriptRoot\..\Functions\Write-W11Report.ps1"
    . $functionUnderTest    
    . $PSScriptRoot\..\Functions\Get-Report.ps1
    . $PSScriptRoot\..\Functions\Populate-FromComputerInfo.ps1
    . $PSScriptRoot\..\Functions\Populate-FromDxDiag.ps1
}

Describe 'Write-W11Report' {
    BeforeEach{        
        $report = Get-Report
        $report = Populate-FromComputerInfo -Report $report
        $report = Populate-FromDxDiag -Report $report

    }
    Context "Given it is invoked" {           
        It "Populates the report with no errors" { 
            Write-W11Report -Report $report
        }
    }
}