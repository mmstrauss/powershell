#Sam's script to check if the Receipt Reprint App is installed
Invoke-Command -ComputerName (Get-AdComputer -Filter * -Server asd.msp.htec.co.uk -SearchBase "OU=ASDA,DC=ASD,DC=MSP,DC=htec,DC=co,DC=uk" | Where-Object { $_.Name -match "CTRL" -and $_.Name -notmatch "9999|9998|xxxx" } | Select-Object -ExpandProperty DNSHostName) -ScriptBlock {
    [PSCustomObject]@{
        "IsInstalled" = Test-Path -Path 'C:\Program Files (x86)\HTECReceiptReprint\ReceiptReprint.exe'        
        "HasDesktopShortcut" = Test-Path -Path 'C:\Users\Public\Desktop\OPT Receipt Reprint.lnk'
    }