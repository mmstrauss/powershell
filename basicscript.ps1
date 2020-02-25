#Copy of script from Automation with Powershell Scripts, Pluralsight
#breakdown of error sources in System eventlog

#start with cmd prompt 
$computername = $env:computername
$data = Get-Eventlog System -EntryType Error -Newest 1000 -ComputerName $ComputerName
Group -Property  Source -NoElement

#create an HTML Report
$title = "System Log Analysis"
$footer = "<h5> Report run$(Get-Date)</h5>"
#$css ="http://jdhitsolutions.com/sample.css"

$data | Sort -Property Count, Name - Descending |
select Count,NameConvertTo-Html -Title $Title -PreContent "<h1>$Computername</h1>" -PostContent
Out-File c:\work\systemresources.html

#Invoke-Item c:\work\systemsources.html
