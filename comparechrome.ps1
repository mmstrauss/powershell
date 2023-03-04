::Comparing different files
Get-ChildItem -Path 'c:\installs\' -Filter statemessages -File -Recurse | Get-FileHash | Group-Object Hash 