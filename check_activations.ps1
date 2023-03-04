[array]$computerlist = "ASDA4792CTRL1","ASDA5146POS3","ASDA4794ANPR","ASDA4597ANPR","ASDA4618ANPR"
for ($x = 0; $x -lt $computerlist.Count; $x++) { $computerlist[$x] = $computerlist[$x] + ".asd.msp.htec.co.uk" }
function Get-WindowsActivationStatus {
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$ComputerName
    )
    process {
        $splatArgs = @{
            ComputerName = $ComputerName
            ClassName    = 'SoftwareLicensingProduct'
            Filter       = 'PartialProductKey IS NOT NULL AND Name LIKE "Windows%"'
            Property     = "LicenseStatus"
        }
        $licenseStatus = Get-CimInstance @splatArgs
        
        [PSCustomObject]@{
            PSComputerName = $ComputerName
            LicenseStatus  = $LicenseStatus.LicenseStatus
        }
    }
}
$computerlist | Get-WindowsActivationStatus | ConvertTo-Csv -NoTypeInformation | Tee-Object -FilePath 'C:\Users\sgreatorex\ASDA_LicenseStatus.csv' | ConvertFrom-Csv