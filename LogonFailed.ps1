Function LogonFailed {
$f = select-string -path audit.log -pattern "logon failed" -context 2, 3
$f.count
($f)[0].context | format-list
}

LogonFailed | Out-GridView