


function test-activation {

$computerList = Read-Host 'Enter computer name'

#checks Windows Activation status
$ta = Get-CimInstance -ClassName SoftwareLicensingProduct -Filter “PartialProductKey IS NOT NULL” |
Where-Object -Property Name -Like “Windows*”

if ($ta.LicenseStatus -eq 1) {$true} else {$false}
}

test-activation