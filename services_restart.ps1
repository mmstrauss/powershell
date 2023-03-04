
powershell
Invoke-Command -ScriptBlock {

$s = 'bits', 'wuauserv','cryptsvc'
restart-service $s
get-service $s

}