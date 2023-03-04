Invoke-Command -ComputerName (Get-AdComputer -Filter * -SearchBase "OU=ASDA,DC=ASD,DC=MSP,DC=htec,DC=co,DC=uk" -Server asd.msp.htec.co.uk | Where-Object { $_.Name -notmatch "9999|9998" } | Select-Object -ExpandProperty DNSHostName) -ScriptBlock {
    $iFaceIdx = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { ([System.BitConverter]::ToUInt32(([ipaddress]::Parse($_.IPAddress).GetAddressBytes()), 0) -band 65535) -eq 4524 } | Select-Object -ExpandProperty InterfaceIndex
    if ($iFaceIdx) {
        [PSCustomObject]@{
            DNSClientServerAddress = (Get-DNSClientServerAddress -InterfaceIndex $iFaceIdx -AddressFamily IPv4 | Select-Object -ExpandProperty ServerAddresses) -join '; '
        }
    }
} | Select-Object PSComputerName, DNSClientServerAddress | ConvertTo-Csv -NoTypeInformation | Tee-Object "C:\Users\$($env:USERNAME)\Desktop\ASDA_DNS.csv" | ConvertFrom-Csv
    
    
  
  

