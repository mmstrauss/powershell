#Check diskspace
#Check c:\windows\SoftwareDistribution\ exist
#Check c:\windows\system32\catroot and catroot2 exist

#resetting components
Write-Host "Stopping related services"

$Services = "wuauserv","bits","cryptSvc"
if (Get-Service $Services -ErrorAction SilentlyContinue)
{
    Write-Host "$Services running"
    Stop-Service $Services
    Get-Service $Services
    }

Write-Host "Press any key to continue..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
cd\
Rename-Item c:\windows\softwaredistribution softwaredistribution.bak

Write-Host "Press any key to continue..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
Rename-Item C:\Windows\System32\catroot2 Catroot2.bak

Write-Host "Press any key to continue..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
STart
(Get-Service $Services | Start-Service $Services)

Write-Host "Press any key to continue..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
SFC /scannow
Write-Host "Press any key to continue..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

DISM /Online /Cleanup-Image /CheckHealth
Write-Host "Press any key to continue..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

DISM /Online /Cleanup-Image /ScanHealth
Write-Host "Press any key to continue..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

DISM /Online /Cleanup-Image /RestoreHealth
Write-Host "Press any key to continue..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

“wuauclt.exe /updatenow”



