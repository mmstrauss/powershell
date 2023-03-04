::Comparing different files
Get-ChildItem -Path 'Y:\Henry\ASDA\Site config\SITEDATA\' -Filter statemessages -File -Recurse | Get-FileHash | Group-Object Hash 