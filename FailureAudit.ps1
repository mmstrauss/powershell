GET-EVENTLOG -Logname Security | where { $_.EntryType -eq 'FailureAudit' } 

#| export-csv C:\Failures.csv https://social.technet.microsoft.com/Forums/ie/en-US/00a62492-c63a-4c8b-92f9-1cc857223a00/powershell-script-to-gather-failed-logon-attempts-by-event-id-and-type-from-the-security-events-log?forum=ITCG