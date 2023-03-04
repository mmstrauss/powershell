#Get OU group, start service if its not running and show list

$Computers = (Get-ADComputer -Filter * -SearchBase "OU=WH5-T-POS1,OU=WH5-T-POS,OU=WH5Desktops-Test,OU=WH5-ASD9999TEST,OU=ASDA,DC=ASD,DC=MSP,DC=htec,DC=co,DC=uk" -Server asd.msp.htec.co.uk | Select-Object -ExpandProperty DNSHostName) 
ForEach ($entry in $Computers)
{ 
Get-Service "eSocket.Pos"  -ComputerName $entry | start-service 
Get-Service "eSocket.Pos"  -ComputerName $entry | Select-Object MachineName, Name,Status, StartType | Format-Table * -AutoSize
}