$FWProfiles = (Get-NetFirewallProfile -PolicyStore ActiveStore);
Write-Host "Windows Firewall Profile Statuses" -Foregroundcolor Yellow;
$FWProfiles | %{
    If($_.Enabled){
        Write-Host "The Windows Firewall $($_.Name) profile is enabled"  -Foregroundcolor Green
        }Else{
        Write-Host "The Windows Firewall $($_.Name) profile is disabled" -Foregroundcolor Red
        } 
    };
