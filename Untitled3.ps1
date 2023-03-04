$computerList = Read-Host 'Enter computer name'


foreach ($computer in $computerList) {

    Get-WmiObject Win32_OperatingSystem -ComputerName $computer |
        Select @{N='ComputerName';E={$computer}},
               @{N='LastBootupTime';E={[System.Management.ManagementDateTimeConverter]::ToDateTime($_.LastBootUpTime)}},
               @{N='Uptime';E={(Get-Date) - ([System.Management.ManagementDateTimeConverter]::ToDateTime($_.LastBootUpTime))}}

}
