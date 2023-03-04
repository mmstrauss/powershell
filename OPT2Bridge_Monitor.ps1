# Events:
#       1000    Error       Script Error/Debug
#
#       1010    Error       Disabled|Offline|Unknown
#       1011    Info        Disabled|Offline|Unknown - Clear
#       1020    Warning     Paper Low
#       1021    Info        Paper Low - Clear
#       1030    Warning     Paper Out
#       1031    Info        Paper Out - Clear
#       1040    Warning     Incorrect IP
#       1041    Info        Incorrect IP - Clear
#       1050    Error       Tampered
#       1051    Info        Tampered - Clear
#       1060    Error       All OPTs Offline
#       1061    Info        All OPTs Offline - Clear
#

function Write-RmmEventLog {
    param (
        [Parameter()]
        [int]$EventId,
        [Parameter()]
        [System.Diagnostics.EventLogEntryType]$EntryType,
        [Parameter()]
        [string]$Message
    )

    $LogName = "htecMonitoring"
    $Source = "OPT2BridgeMonitor"

    if (-not [System.Diagnostics.EventLog]::Exists($LogName) -or -not [System.Diagnostics.EventLog]::SourceExists($Source)) {
        New-EventLog -LogName $LogName -Source $Source
    }
    
    $log = @{
        LogName = $LogName
        Source = $Source
        EntryType = $EntryType
        EventId = $EventId
        Message = $Message
    }

    Write-EventLog @log
}

# Provides the same functionality as the "Using" statement in C# for IDisposable objects
#
#   Use-Object ($sw = [System.IO.StreamWriter]::new("some file.txt")) {
#       $sw.WriteLine('some text')
#   }
#
function Use-Object {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        [AllowNull()]
        [Object]
        $InputObject,
        [Parameter(Mandatory = $true)]
        [scriptblock]
        $ScriptBlock
    )
	
    try {
        . $ScriptBlock
    }
	catch {
		throw
	}
    finally {
        if ($null -ne $InputObject -and $InputObject -is [System.IDisposable]) {
            $InputObject.Dispose()
        }
    }
}

try	{
    #   Sends the debug info command to OPT2Bridge and retrieves the statuses of the OPTs back over the socket
    $received = [Collections.Generic.List[String]]::new()
    Use-Object ($client = New-Object System.Net.Sockets.TcpClient(([ipaddress]::Loopback.IPAddressToString), 51001)) {
        $cStream = $client.GetStream()
        $cStream.Write([byte[]] ( 0x00, 0x00, 0x00), 0, 3)
        Use-Object ($stReader = New-Object System.IO.StreamReader($cStream, [System.Text.Encoding]::UTF8, $true, 1024, $true)) {
            while ($null -ne ($line = $stReader.ReadLine()))
            {
                $received.Add($line)
            }
        }
    }

    if ($null -ne $received -and $received.Count -gt 0) {
        $rawState = $received[4..($received.Count - 2)]
        $version = [regex]::new(".*?([+-]?\d*\.\d+)(?![-+0-9\.])", [System.Text.RegularExpressions.RegexOptions]::IgnoreCase).Match(($received | Select-String "OPT2Bridge v")).Groups[1].Value
    
        $result = @()
        $result += $rawState | ForEach-Object {
            [PSCustomObject]@{
                OPT2BridgeVersion = $version
                Number = $_.Split()[0]
                Serial = $_.Split()[1]
                IPAddress = $_.Split()[2]
                Status = $_.Split()[3]
                TransactionState = $_.Split()[4]
                PaperLevel = $_.Split()[5].Replace("%", "")
                PaperLow = $_.Split()[6]
                PaperOut = $_.Split()[7]
                MediaState = $_.Split()[8]
                Tamper = $_.Split()[9]
            }
        }
        $results += $result
    }
    
    # Add OPT2Bridge to the registry so it can show in the Datto software audit
    if ($version) {
        $regBasePath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\OPT2Bridge"
        if (-not (Test-Path $regBasePath)) {
            New-Item -Path $regBasePath | Out-Null
            New-ItemProperty -Path $regBasePath -Name "Contact" -Value "callreg@htec.co.uk" | Out-Null
            New-ItemProperty -Path $regBasePath -Name "DisplayIcon" -Value "C:\HydraPOS\OPTProg\OPT2Bridge\OPT2Bridge.jar" | Out-Null
            New-ItemProperty -Path $regBasePath -Name "DisplayName" -Value "OPT2Bridge" | Out-Null
            New-ItemProperty -Path $regBasePath -Name "DisplayVersion" -Value $version | Out-Null
            New-ItemProperty -Path $regBasePath -Name "InstallData" -Value (Get-Date -Format "yyyyMMdd") | Out-Null
            New-ItemProperty -Path $regBasePath -Name "Publisher" -Value "htec ltd" | Out-Null
            New-ItemProperty -Path $regBasePath -Name "UninstallString" -Value " " | Out-Null
        }
        else {
            if ($version -ne (Get-ItemProperty -Path $regBasePath -Name "DisplayVersion").DisplayVersion) {
                Set-ItemProperty -Path $regBasePath -Name "DisplayVersion" -Value $version
                Set-ItemProperty -Path $regBasePath -Name "InstallData" -Value (Get-Date -Format "yyyyMMdd")
            }
        }
    }
    
    [array]$offlineDisabled = $results | Where-Object { $_.Status -match "Unknown|Offline|Disabled" }
    [array]$paperLow = $results | Where-Object { $_.PaperLow -eq "" }
    [array]$paperOut = $results | Where-Object { $_.PaperOut -eq "" }
    [array]$wrongIP = $results | Where-Object { $_.IPAddress -ne "Unknown" -and (([ipaddress]$_.IPAddress).GetAddressBytes()[3] - 100) -eq $_.Number }
    [array]$tampered = $results | Where-Object { $_.Tamper -ne "" }
    
    if ($results.Count -eq $offlineDisabled.Count) {
        Write-RmmEventLog -EventId 1060 -EntryType Error -Message "All OPTs Offline"
        exit
    }
    else {
        Write-RmmEventLog -EventId 1061 -EntryType Information -Message "All OPTs Offline - Clear"
    }

    if ($offlineDisabled.Count -gt 0) {
        Write-RmmEventLog -EventId 1010 -EntryType Error -Message "Offline OPTs: $($offlineDisabled.Number -join ', ')"
    }
    else {
        Write-RmmEventLog -EventId 1011 -EntryType Information -Message "Offline OPTs Clear"
    }

    if ($paperLow.Count -gt 0) {
        Write-RmmEventLog -EventId 1020 -EntryType Warning -Message "Paper Low: $($paperLow.Number -join ', ')"
    }
    else {
        Write-RmmEventLog -EventId 1021 -EntryType Information -Message "Paper Low Clear"
    }

    if ($paperOut.Count -gt 0) {
        Write-RmmEventLog -EventId 1030 -EntryType Warning -Message "Paper Out: $($paperOut.Number -join ', ')"
    }
    else {
        Write-RmmEventLog -EventId 1031 -EntryType Information -Message "Paper Out Clear"
    }

    if ($wrongIP.Count -gt 0) {
        Write-RmmEventLog -EventId 1040 -EntryType Warning -Message "Incorrect IP: `r`n$($wrongIP | ForEach-Object { "$($_.Number)`t`t $($_.IPAddress)`r`n" })"
    }
    else {
        Write-RmmEventLog -EventId 1040 -EntryType Information -Message "Incorrect IP Clear"
    }

    if ($tampered.Count -gt 0) {
        Write-RmmEventLog -EventId 1050 -EntryType Error -Message "TAMPERED: $($tampered.Number -join ', ')"
    }
    else {
        Write-RmmEventLog -EventId 1051 -EntryType Information -Message "Tamper Clear"
    }

    
}
catch [System.Net.Sockets.SocketException] {
    Write-RmmEventLog -EventId 1000 -EntryType Error -Message "Failed to connect to OPT2Bridge: '$($_.Exception.Message)'"
}
catch {
    Write-RmmEventLog -EventId 1000 -EntryType Error -Message "Unknown error: '$($_.Exception.Message)'"
}