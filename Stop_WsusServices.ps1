Function Stop_WsusServices{
$s = "bits", "wuauserv", "cryptsvc"
stop-service $s -Verbose ; get-service $s
Set-Service -Name "bits" -StartupType Manual
Set-Service -Name "wuauserv" -StartupType Manual
Set-Service -Name "cryptsvc" -StartupType Manual
Get-Service $s | Select-Object -Property Name, DisplayName, StartType, Status
#Get-Service $s | Select-Object -Property *

}
Stop