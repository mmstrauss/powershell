Write-Host $env:COMPUTERNAME
        Write-Host (Get-ItemProperty HKCU:\Software\Microsoft\windows\Shell\Associations\UrlAssociations\http\UserChoice).Progid
        Write-Host "`n"