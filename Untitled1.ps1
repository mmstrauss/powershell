
#copy list of computers into the Computer variable (Get list from grafana activation board)
[array]$computers = 'ASDA4792CTRL1'
append FQDN suffix to names
for ($x = 0; $x -lt $computers.Count; $x++) { $computers[$x] = $computers[$x] + ".asd.msp.htec.co.uk" }
Invoke-Command -ComputerName $computers -ScriptBlock 
{
function Get-ActivationStatus
{
[CmdletBinding()]
 param(
 [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
 [string]$ComputerName = $Computers
 )
 process {
 try {
 $wpa = Get-WmiObject SoftwareLicensingProduct -ComputerName $Computers `
 -Filter "ApplicationID = '55c92734-d682-4d71-983e-d6ec3f16059f'" `
 -Property LicenseStatus -ErrorAction Stop
 } catch {
 $status = New-Object ComponentModel.Win32Exception ($_.Exception.ErrorCode)
 $wpa = $null 
 }
 $out = New-Object psobject -Property @{
 ComputerName = $DNSHostName;
 Status = [string]::Empty;
 }
 if ($wpa) {
 :outer foreach($item in $wpa) {
 switch ($item.LicenseStatus) {
 0 {$out.Status = "Unlicensed"}
 1 {$out.Status = "Licensed"; break outer}
 2 {$out.Status = "Out-Of-Box Grace Period"; break outer}
 3 {$out.Status = "Out-Of-Tolerance Grace Period"; break outer}
 4 {$out.Status = "Non-Genuine Grace Period"; break outer}
 5 {$out.Status = "Notification"; break outer}
 6 {$out.Status = "Extended Grace"; break outer}
 default {$out.Status = "Unknown value"}
 }
 }
 } else { $out.Status = $status.Message }
 $out
 }
 }
Get-ActivationStatus > c:\temp\act.txt
}