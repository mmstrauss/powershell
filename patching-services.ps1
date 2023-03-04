Invoke-Command -ScriptBlock {
#fix for Error 0x800f098
dism /online /cleanup-image /startcomponentcleanup
Stop-Service bits, wuauserv, cryptsvc -Verbose
Start-Sleep -s 2
ren C:\Windows\SoftwareDistribution SoftwareDistribution.old
ren C:\Windows\System32\catroot2 Catroot2.old
Get-Service bits, wuauserv,cryptsvc | start-service -Verbose
}