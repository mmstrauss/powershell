    $computerList = @("Server1", "server2")
$cred = Get-Credential

ForEach ($Computer in $computerList) {

    New-PSSession -ComputerName $Computer -Credential $cred | Out-Null
    Invoke-Command -Session (Get-PSSession) -ScriptBlock {
        Write-Host $env:COMPUTERNAME
        Write-Host (Get-ItemProperty HKCU:\Software\Microsoft\windows\Shell\Associations\UrlAssociations\http\UserChoice).Progid
        Write-Host "`n"
    }
    Get-PSSession | Remove-PSSession

}