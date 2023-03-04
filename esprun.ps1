#MM Strauss 18/03/2021
#Checks if Esocket.POS is running if not, start it
#logs output to temp location

function FuncCheckService
{
    param($ServiceName)
        $arrService = Get-Service -Name $ServiceName
        $Date = Get-Date -Format "MM/dd/yyyy HH:mm:ss"
        $Name = $env:computername
        $Start = "Stopped "
        $Started = " service is already started."
            if ($arrService.Status -eq "Stopped")
            {
                Start-Service $ServiceName
                ($Date + " - " + $name + " - " + $Start + $ServiceName) | Out-file \\SO-MSP-APP02\c$\install\Temp\logs\ServiceLog.txt -append 
            }
            if ($arrService.Status -eq "Running")
            { 
                ($Date + " - " + $name + " - " + $ServiceName + $Started) | Out-file \\SO-MSP-APP02\c$\install\Temp\logs\ServiceLog.txt -append 
            }
}
 
FuncCheckService -ServiceName "Esocket.POS"