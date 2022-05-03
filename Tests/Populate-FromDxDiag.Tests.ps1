BeforeAll { 
    $functionUnderTest = "$PSScriptRoot\..\Functions\Populate-FromDxDiag.ps1"
    . $functionUnderTest    
    . $PSScriptRoot\..\Functions\Get-Report.ps1
}

Describe 'Populate-FromDxDiag' {
    BeforeEach{        
        $report = Get-Report
    }
    Context "Given it is invoked" {           
        It "Populates the report with no errors" { 
            $report = Populate-FromDxDiag -Report $report
        }
    }
}