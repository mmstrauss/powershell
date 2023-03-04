Function GetAppErrors {
$Events = Get-WinEvent -LogName Application -MaxEvents 50
$Events | Select-String -InputObject {$_.message} -Pattern 'Failed'
}
GetAppErrors | Out-GridView