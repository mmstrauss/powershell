#This script stops the device registering its 192 address on the DNS Servers

$adaptorinfo = Get-WmiObject  Win32_NetworkAdapterConfiguration | where {$_.IPAddress -match "172.17."}
$servicename = $adaptorinfo.Servicename
$IPS = $adaptorinfo.IPAddress | where {$_ -notmatch "172.17"}
$Adaptorname = (Get-WmiObject -Class Win32_NetworkAdapter | where {$_.servicename -eq "$servicename"}).InterfaceIndex
FOREACH ($IP in $IPS)
{
    $CMD1 = "Netsh int ipv4 delete address "+$Adaptorname+" addr="+$IP
    $CMD1 | cmd
    $CMD2 = "Netsh int ipv4 add address "+$Adaptorname+" addr="+$IP+" 255.255.255.0 skipassource=true"
    $CMD2 | cmd
}