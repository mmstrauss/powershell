$wShell = New-Object -comObject WScript.Shell
$shortcut = $wShell.CreateShortcut('C:\Users\Public\Desktop\MultiCamStudio.lnk')
$shortcut.TargetPath = 'C:\Program Files (x86)\Euresys\MultiCam\Bin\x86_64\MulticamStudio.exe'
$shortcut.Save()