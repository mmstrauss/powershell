# Create a Shortcut for Multicam with Windows PowerShell
$SourcefileLocation = "C:\Program Files (x86)\Euresys\MultiCam\Bin\x86_64\MulticamStudio.exe"
$ShortcutLocation = "C:\Users\public\desktop\MultiCamStudio.lnk"
#-ComObject WScript.Shell: This creates an instance of the COM object that represents the WScript.Shell for invoke CreateShortCut
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutLocation)
$Shortcut.TargetPath = $SourceFileLocation
#Save the Shortcut to the TargetPath
$Shortcut.Save()