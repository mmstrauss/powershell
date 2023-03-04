function HSCPatchCheck{
$HSCServices = 'HydraFileSendService','ESET Service','EraAgentSvc','SCMk3StatusService'
$HSCProc = 'IPserialServer','HydraFDC','IPSerialWatcher','HFDCWatcher','Washlink' | get-service $HSCProc

Get-Service $HSCServices
Get-Process $HSCProc

powershell (get-hotfix | sort installedon)[-1]


param($HSCServices)
$arrHSCServices = Get-Service -Name $HSCServices              