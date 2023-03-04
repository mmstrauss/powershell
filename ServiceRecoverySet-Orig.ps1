 function Set-ServiceRecovery{

    [alias('Set-Recovery')]
    param
    (
        [string] [Parameter(Mandatory=$true)] $ServiceDisplayName,
        [string] [Parameter(Mandatory=$true)] $Server,
        [string] $action1 = "restart",
        [int] $time1 =  60000, # in miliseconds
        [string] $action2 = "restart",
        [int] $time2 =  60000, # in miliseconds
        [string] $actionLast = "restart",
        [int] $timeLast = 60000, #in miliseconds
        [int] $resetCounter = 4000 #second
    )
    $serverPath = "\\" + $server

    $services = Get-CimInstance -ClassName 'Win32_Service' -ComputerName $Server| Where-Object {$_.DisplayName -imatch $ServiceDisplayName}
    $action = $action1+"/"+$time1+"/"+$action2+"/"+$time2+"/"+$actionLast+"/"+$timeLast
    foreach ($service in $services){
        $output = sc.exe $serverPath failure $($service.Name) actions= $action reset= $resetCounter
    }
}
Set-ServiceRecovery -ServiceDisplayName "UPnP Device Host" -Server "$env:COMPUTERNAME"

#sets the reset fail counters to reset in 1minute