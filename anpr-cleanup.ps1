#Begin
#NL V1 15/04/20
#Getting current system date, works out the date of 90 days ago then converts to a string 

$date = (((get-date).AddDays(-90)).ToString('yyyy-MM-dd'))

#Stopping ANPR services
Stop-Service Htec.ANPR.ForecourtProtect.UI.Service -verbose | out-file C:\temp\ANPRClearDownLog.txt -Append
stop-service Htec.ANPR.ForecourtProtect.API -verbose | out-file C:\temp\ANPRClearDownLog.txt -Append

#gets all files on the ANPR media drive, filters them by age and then removes files older than 90 days. Each removed file is logged to "c:\temp\ANPRCleardownLog.txt"
Get-ChildItem d:\*.aes -Recurse -Force -File -PipelineVariable File | Where-Object -Filterscript {($_.LastWriteTime -lt $date)} | % {
    try {
        Remove-Item -Path $File.fullname -Force -Confirm:$false -ErrorAction Stop
        "Deleted file: $($File.fullname)" | Out-File c:\temp\ANPRClearDownLog.txt -Append
    } catch {
        "Failed to delete file: $($File.fullname)" | Out-File c:\temp\ANPRClearDownLog.txt -Append        
    }
}

#Restarts the ANPR services
start-service Htec.ANPR.ForecourtProtect.API -verbose | out-file C:\temp\ANPRClearDownlog.txt -Append
Start-Service Htec.ANPR.ForecourtProtect.UI.Service -verbose | out-file C:\temp\ANPRClearDownLog.txt -Append

#Show the status of the Services to confirm they did come back up properly.
get-service HTEC.ANPR* -Verbose 

#End
