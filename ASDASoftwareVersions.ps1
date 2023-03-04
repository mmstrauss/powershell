$computers = Get-AdComputer -Filter * -Server asd.msp.htec.co.uk -SearchBase "OU=ASDA,DC=ASD,DC=MSP,DC=htec,DC=co,DC=uk" | Where-Object { $_.Name -notmatch "9999|9998|xxxx" } | Select-Object -ExpandProperty DNSHostName 
Invoke-Command -ComputerName $computers -ScriptBlock {
    $allPrograms = @(
        "C:\Datasender5\DataSender5.exe",
        "C:\ANPR\SHWAPI\Assemblies\ANPR.ForecourtProtect.dll",
        "C:\ANPR\UI\ANPR.ForecourtProtect.UI.exe",
        "C:\HydraPOS\Progs\HydraFileSend.exe",
        "C:\HydraPOS\Progs\UnmannedPseudoPOS.exe",
        "C:\HydraPOS\OPTProg\HydraEMVOPT.exe",
        "C:\HydraPOS\POSProg\HydraPOS.exe",
        "C:\Program Files (x86)\HTEC Ltd\HydraFDC\HydraFDC.exe"
    )

    $allPrograms | Where-Object { Test-Path $_ } | ForEach-Object {
        [PSCustomObject]@{
            Name = [System.IO.Path]::GetFileName($_)
            Path = $_
            Version = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($_).FileVersion
            Hash = (Get-FileHash $_ -Algorithm SHA256).Hash
            Size = (Get-Item $_).Length
        }
    }
}
