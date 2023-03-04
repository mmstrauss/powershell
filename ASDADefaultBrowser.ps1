#Written 12/11/2021
#Array- OU specified
$Computers=(Get-ADComputer -Filter * -SearchBase "OU=WH5-T-ANPR,OU=WH5Desktops-Test,OU=WH5-ASD9999TEST,OU=ASDA,DC=ASD,DC=MSP,DC=htec,DC=co,DC=uk" -Server asd.msp.htec.co.uk | Select-Object -ExpandProperty DNSHostName) 
$Browser=Get-ItemProperty "HKLM:\SOFTWARE\Classes\http\shell\open\command" | Select-Object -ExpandProperty "(default)" 

$Results = ForEach($computer in $Computers){
   Invoke-Command -ScriptBlock{
    [PSCustomObject]@{
        ComputerName = $Computer
        Browser = $Browser
        }
    }
}

$Results | Export-Csv "c:\temp\ASDA-1.csv" -NoTypeInformation