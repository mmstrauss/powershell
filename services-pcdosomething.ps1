﻿$servicename = "SomeService"

$list = get-content “c:\ps\comp_list.txt”

foreach ($server in $list) {

if (Get-Service $servicename -computername $server -ErrorAction 'SilentlyContinue'){

Write-Host "$servicename exists on $server "

# do something

}

else{write-host "No service $servicename found on $server."}

}