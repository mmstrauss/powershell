Get-WinEvent -ComputerName localhost -FilterHashtable @{Logname= 'System'; id = 1074,6005, 6006,6008} | Format-Table -wrap


   