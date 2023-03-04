
# Usage example
# Install-MySoftware -Computers dc1,dc2,svr12,svr16 -Packages 'powershell.portable','microsoft-edge','microsoft-windows-terminal'
Function Install-MySoftware {
    [CmdletBinding()]
    Param(
        [Parameter()]
        [string[]]$Computers,

        [Parameter()]
        [string[]]$Packages
    )

    $liveComputers = [Collections.ArrayList]@()

    foreach ($computer in $computers) {
        if (Test-Connection -ComputerName $computer -Quiet -count 1) {
            $null = $liveComputers.Add($computer)
        }
        else {
            Write-Verbose -Message ('{0} is unreachable' -f $computer) -Verbose
        }
    }

    $liveComputers | ForEach-Object {
        Invoke-Command -ComputerName $_ -ScriptBlock {
            $Result = [Collections.ArrayList]@()

            $testchoco = Test-Path 'C:\ProgramData\chocolatey'
            if ($testchoco -eq $false) {
                Write-Verbose -Message "Chocolately is not installed on $($Env:COMPUTERNAME). Please install and try again." -Verbose
            } 
            
            }

            foreach ($Package in $using:Packages) {
                choco Install $Package -y | Out-File -FilePath "c:\temp\choco-$Package.txt"
                if ($LASTEXITCODE -eq '1641' -or '3010') {
                    # Reference: https://chocolatey.org/docs/commandsinstall#exit-codes
                    # create new custom object to keep adding information to it
                    $Result += New-Object -TypeName PSCustomObject -Property @{
                        ComputerName     = $Env:COMPUTERNAME
                        InstalledPackage = $Package
                    }
                }
                else {
                    Write-Verbose -Message "Packages failed on $($Env:COMPUTERNAME), see logs in c:\windows\temp" -Verbose
                }
            } $Result 
        }     
    
    } | Select-Object ComputerName, InstalledPackage | Sort-Object -Property ComputerName
