$sesh = New-PSSession ASDA4922ANPR.asd.msp.htec.co.uk
Copy-Item -Path C:\whatever -Destination C:\whatever -FromSession $sesh
Remove-PSSession $sesh