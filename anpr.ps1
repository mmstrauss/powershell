Invoke-Command -ComputerName ASDA9998ANPR.asd.msp.htec.co.uk, ASDA9999ANPR.asd.msp.htec.co.uk -ScriptBlock {
    choco upgrade anpr-api -y
    $apiExitCode = $LASTEXITCODE
    
    choco upgrade anpr-ui -y
    $uiExitCode = $LASTEXITCODE

    [PSCustomObject]@{
        APIExitCode = $apiExitCode;
        UIExitCode = $uiExitCode;
    }
} | Select-Object PSComputerName, APIExitCode, UIExitCode | ConvertTo-Csv -NoTypeInformation | Tee-Object C:\Scripts\ASDA\Choco\Logs\installs.csv | ConvertFrom-Csv

