$computerList = @("asda999anpr.asd.msp.htec.oc.uk", "asda9998anpr.asd.msp.htec.co.uk")
$cred = Get-Credential

ForEach ($Computer in $computerList) {

    Invoke-Command <!..-Session (Get-PSSession) --> -ScriptBlock {
        #Write-Host $env:COMPUTERNAME
        Write-Host (Get-ItemProperty HKCU:\SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice).Progid
        Write-Host (Get-ItemProperty HKCU:\Software\Microsoft\windows\Shell\Associations\UrlAssociations\https\UserChoice).Progid
        Write-Host "`n"
    }

}

