
Invoke-Command -ScriptBlock { 
Start-Service 'eSocket.POS' -Verbose
Get-Service 'eSocket.POS'
}