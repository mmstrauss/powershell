Invoke-Command -ComputerName ASDA4163ANPR.asd.msp.htec.co.uk , ASDA4188ANPR.asd.msp.htec.co.uk ,ASDA41221ANPR.asd.msp.htec.co.uk ,ASDA4583ANPR.asd.msp.htec.co.uk,ASDA4596ANPR.asd.msp.htec.co.uk,ASDA4667ANPR.asd.msp.htec.co.uk,ASDA4669ANPR.asd.msp.htec.co.uk,ASDA4841ANPR.asd.msp.htec.co.uk -ScriptBlock {Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://choco.dataservices.htec.co.uk/install.ps1'))}
#next set the chocolatey source server
Invoke-Command -ComputerName ASDA4163ANPR.asd.msp.htec.co.uk , ASDA4188ANPR.asd.msp.htec.co.uk ,ASDA41221ANPR.asd.msp.htec.co.uk ,ASDA4583ANPR.asd.msp.htec.co.uk,ASDA4596ANPR.asd.msp.htec.co.uk,ASDA4667ANPR.asd.msp.htec.co.uk,ASDA4669ANPR.asd.msp.htec.co.uk,ASDA4841ANPR.asd.msp.htec.co.uk -ScriptBlock {
    #New-Item -Path C:\Logs\ -ItemType Directory
    choco source add -n=htecprod -s="https://choco.dataservices.htec.co.uk/chocolatey/"
    
#for existing application, use 'choco upgrade packagename'
#for new application use 'choco install packagename -y'
choco upgrade chrome -y
}