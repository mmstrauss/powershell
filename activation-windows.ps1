Function Get-ComputerList
{
 [array]$computers = "ASDA9999CTRL1"

# append FQDN suffix to names
for ($x = 0; $x -lt $computers.Count; $x++) { $computers[$x] = $computers[$x] + ".asd.msp.htec.co.uk" }
}

Function Get-WindowsActivation 
{
    <#
        This is a PowerShell advanced function to retrieve the Windows Activation Status using CIM classes.
        It takes one or more computers as an input, and it accepts through pipeline as well
        This script will check the connectivity, and then checks the activation status
        It collects the info from all the servers and then return the value of error at once.
    #>

    [CmdLetBinding()]
    Param
    (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string[]] $Computers
    )
    Begin
    {
        $ActivationStatus = @()
    }
    Process
    {
        foreach ($CN in $Computers)
        {
            $PingStatus = Test-Connection -ComputerName $CN -ErrorAction Stop -Count 1 -Quiet
            $SPL = Get-CimInstance -ClassName SoftwareLicensingProduct -ComputerName $CN -Filter "PartialProductKey IS NOT NULL" -ErrorAction Stop
            $WinProduct = $SPL | Where-Object Name -like "Windows*" 
            $Status = if ($WinProduct.LicenseStatus -eq 1) { "Activated" } else { "Not Activated" }
            if ($PingStatus -ne $true)
            {
                $PingStatus = "No"
                $Status = "Error"
            } else { $PingStatus = "Yes" }
            $ActivationStatus += New-Object -TypeName psobject -Property @{
                ComputerName = $CN
                Status = $Status
                IsPinging = $PingStatus
            }
        }
    }
    End
    {
        return $($ActivationStatus | Select-Object -Property ComputerName, IsPinging, Status)
    }
}
 
## Invoke the functions, export to csv
Get-Computerlist | Get-WindowsActivation |export-csv  c:\temp\fillin.csv -nti