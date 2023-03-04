[array]$bomgarInstances = Get-Service | Where-Object { $_.DisplayName -match "BeyondTrust Remote Support Jump Client" }
[array]$runningInstances = $bomgarInstances | Where-Object { $_.Status -eq "Running" }
 
if ($bomgarInstances.Count -gt 1 -and $runningInstances.Count -eq 1) {
    $instancesToDelete = $bomgarInstances | Where-Object { $_ -ne $runningInstances[0] }
    
    foreach ($bomgarInstance in $instancesToDelete) {
        $service = Get-WmiObject -Class Win32_Service -Filter "Name = '$($bomgarInstance.Name)'"
        $service.Delete()
    }
}
