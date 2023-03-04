$iFaceIdx = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { ([ipaddress]::Parse($_.IPAddress).Address -band 65535) -eq 4524 } | Select-Object -ExpandProperty InterfaceIndex
if ($iFaceIdx) {
    Set-DnsClientServerAddress -InterfaceIndex $iFaceIdx -ServerAddresses ("192.168.107.11","192.168.108.11")
}
