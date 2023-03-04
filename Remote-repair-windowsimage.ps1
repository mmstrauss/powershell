$ASD_computername = 'ASDA9998CTRL1.ASD.MSP.htec.co.uk'
$comp_infile = 'c:\install\ctrlcomps.txt'

#test server
$ASD_WSUS_Server = 'wsus-test.asd.msp.htec.co.uk'
#prod server
#$ASD_WSUS_Server = 'wsus.asd.msp.htec.co.uk'

$asd_wim_path = '\\' + $ASD_WSUS_Server + '\patch\install1809.wim:1'

write-host $asd_wim_path

$farm = Get-Credential

foreach ($ASD_computername in [System.IO.File]::ReadLines($comp_infile))
{

        # enable credssp on this server
        Enable-WSManCredSSP -role client -DelegateComputer $ASD_computername -force
        Get-WSManCredSSP

        #setup credssp on target device
        invoke-command -computername $ASD_computername -scriptblock {
            enable-wsmancredssp -role server -force
            Get-WSManCredSSP
                    } -Credential $farm
            
        # repair image on target and disable credssp
        invoke-command -computername $ASD_computername -scriptblock {
            &dism /online /cleanup-image /restorehealth /source:wim:\\wsus-test.ASD.MSP.htec.co.uk\patch\install1809.wim:1 /LimitAccess
            disable-wsmancredssp -role server
            Get-WSManCredSSP
                } -credential $farm -Authentication Credssp



        # disable credssp on this server
        Disable-WSManCredSSP –Role Client
        Get-WSManCredSSP
}
