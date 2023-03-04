$A = get-content -path .\ANPR.ForecourtProtect_Instrumentation.*
$pump = 1
$StartTime = Get-content -Path .\ANPR.ForecourtProtect_Instrumentation.* | Sort-Object | Select -First 1
$EndTime = Get-content -Path .\ANPR.ForecourtProtect_Instrumentation.* | Sort-Object | Select -Last 1

Write-host "From"$StartTime.SubString(0,20)"to"$EndTime.SubString(0,20)""

foreach($i in 1..12){
    write-host "pump $pump success:" (Select-String "read,$pump," -InputObject $A -AllMatches).Matches.Count "failed:" (Select-String "noreg,$pump," -InputObject $A -AllMatches).Matches.Count 
    $pump++
}

write-host "total success:" (Select-String "read," -InputObject $A -AllMatches).Matches.Count "failed:" (Select-String "noreg," -InputObject $A -AllMatches).Matches.Count 

