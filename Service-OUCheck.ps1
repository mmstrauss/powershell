#Script to see if Esocket.POS is running in a specified OU
#Get-Service -Name esprun -ComputerName (Get-ADComputer -Filter * -SearchBase "OU=PILOT-CTRL,OU=PILOTDESKTOPS,OU=PILOTSITES,OU=ASDA,DC=ASD,DC=MSP,DC=htec,DC=co,DC=UK" -Server asd.msp.htec.co.uk | Select-Object -ExpandProperty DNSHostName) | Select-Object MachineName, Name, DisplayName, Status, StartType | Format-Table -AutoSize

#CTRL PC's
#Get-Service -Name esprun -ComputerName (Get-ADComputer -Filter * -SearchBase "OU=Orange-B,OU=ASDA-CTRL,OU=ASDADesktops,OU=SITES,OU=ASDA,DC=ASD,DC=MSP,DC=htec,DC=co,DC=uk" -Server asd.msp.htec.co.uk | Select-Object -ExpandProperty DNSHostName) | Select-Object MachineName, Name, DisplayName, Status, StartType | Format-Table -AutoSize

#POS 1's
Get-Service -Name esprun -ComputerName (Get-ADComputer -Filter * -SearchBase "OU=Orange-B,OU=ASDA-POS1,OU=ASDA-POS,OU=ASDADesktops,OU=SITES,OU=ASDA,DC=ASD,DC=MSP,DC=htec,DC=co,DC=uk" -Server asd.msp.htec.co.uk | Select-Object -ExpandProperty DNSHostName) | Select-Object MachineName, Name, DisplayName, Status, StartType | Format-Table -AutoSize
