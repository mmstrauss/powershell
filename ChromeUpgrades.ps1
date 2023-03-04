# This script will check the Windows activation status. If the activation status equals 1, the script will return TRUE.
# Please remember to change the array

function ChromeUpgrades {

[array]$computerlist =

# append FQDN suffix to names
for ($x = 0; $x -lt $computers.Count; $x++) { $computers[$x] = $computers[$x] + ".asd.msp.htec.co.uk" }

foreach($Computer in $Computerlist){
Invoke-Command $computerlist -ScriptBlock {
    choco upgrade GoogleChrome -y
}}
 }
$computerlist | ChromeUpgrades | ConvertTo-Csv -NoTypeInformation | Tee-Object $env:USERPROFILE\Desktop\GoogleChromeInstalls20092021.csv | ConvertFrom-Csv
#$computerlist | ChromeUpgrades | ConvertTo-Csv -NoTypeInformation | Tee-Object -FilePath 'C:\scripts\.csv' | ConvertFrom-Csv