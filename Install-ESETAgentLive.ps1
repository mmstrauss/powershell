$currentIdentity = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
If (-not $currentIdentity.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script must be run as an Administrator"
}
else {
    $serverHostname = "av-test.asd.msp.htec.co.uk"
    $serverPort = 2222
    $peerCertB64 = 'MIILKgIBAzCCCuYGCSqGSIb3DQEHAaCCCtcEggrTMIIKzzCCBhgGCSqGSIb3DQEHAaCCBgkEggYFMIIGATCCBf0GCyqGSIb3DQEMCgECoIIE'
    $peerCertPwd = $null
    $caCertB64 = 'MIID8zCCAtugAwIBAgIQPH3i9rfISJlJ08ha3VuaqzANBgkqhkiG9w0BAQUFADCBkTEnMCUGA1UEAxMeU2VydmVyIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MSAwHgYDVQQLExdBU0RBIC0gSFRFQyBEYXRhIENlbnRyZTENMAsGA1UEChMESFRFQzEUMBIGA1UEBxMLU291dGhhbXB0b24xEjAQBgNVBAgTCUhhbXBzaGlyZTELMAkGA1UEBhMCR0IwHhcNMTgwODA2MjMwMDAwWhcNMjgwODA3MjMwMDAwWjCBkTEnMCUGA1UEAxMeU2VydmVyIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MSAwHgYDVQQLExdBU0RBIC0gSFRFQyBEYXRhIENlbnRyZTENMAsGA1UEChMESFRFQzEUMBIGA1UEBxMLU291dGhhbXB0b24xEjAQBgNVBAgTCUhhbXBzaGlyZTELMAkGA1UEBhMCR0IwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC7FoL6EC'
    $productUuid = $null
    $initialSGToken = 'NTJjZmMwYTUtZmZjNi00YjU0LWIyYjEtNGNiZmEzYzM4MGYzP3h5EKLpTQyA2NfmoAeIrYrtDH9Bn0LkoVcZsQAeL7MlpBK43JpWzM3'

    $httpProxyHostname = 'av-test.asd.msp.htec.co.uk'
    $httpProxyPort = '2221'
    $enableTelemetry = 0

    if ([System.Environment]::Is64BitOperatingSystem) {
        $url = 'http://repository.eset.com/v1/com/eset/apps/business/era/agent/v7/7.0.577.0/agent_x64.msi'
        $checksum = '4c2737fc96465e56381620156254b8daec097ef4'
        $packageLocation = "$env:TEMP\agent_x64.msi"
    }
    else {
        $url = 'http://repository.eset.com/v1/com/eset/apps/business/era/agent/v7/7.0.577.0/agent_x86.msi'
        $checksum = '4f9052a7438a67e7e3cf9c7766bcf187b16eb590'
        $packageLocation = "$env:TEMP\agent_x86.msi"
    }
    
    if (Test-Path $packageLocation) {
        Remove-Item $packageLocation
    }

    if (-not ([String]::IsNullOrEmpty($httpProxyHostname) -and [String]::IsNullOrEmpty($httpProxyPort))) {       
        $proxyUri = [System.Uri]::new("http://$httpProxyHostname`:$httpProxyPort")
        Invoke-WebRequest -Uri $url -Proxy $proxyUri -OutFile $packageLocation
    }
    else {
        Invoke-WebRequest -Uri $url -OutFile $packageLocation
    }

    if (Test-Path $packageLocation) {
        $downloadedHash = (Get-FileHash -Path $packageLocation -Algorithm SHA1).Hash
        if ($downloadedHash -eq $checksum) {
            $caPath = "$env:TEMP\era.ca.der.b64"
            $caCertB64 | Out-File $caPath -Force
            $peerCertPath = "$env:TEMP\era.peer.pfx.b64"
            $peerCertB64 | Out-File $peerCertPath -Force

            $installParams = @(
                "/qr /i `"$packageLocation`"  /l*v `"$env:TEMP\ra-agent-install.log`""
                "ALLUSERS=1 REBOOT=ReallySuppress"
                "P_CONNECTION_CHOSEN=Host"
                "P_HOSTNAME=$serverHostname"
                "P_PORT=$serverPort"
                "P_CERT_PATH=$peerCertPath"
                "P_CERT_PASSWORD=$peerCertPwd"
                "P_CERT_PASSWORD_IS_BASE64=YES"
                "P_INITIAL_STATIC_GROUP=$initialSGToken"
                "P_ENABLE_TELEMETRY=$enableTelemetry"
                "P_LOAD_CERTS_FROM_FILE_AS_BASE64=YES"
            )

            if (-not [string]::IsNullOrEmpty($caCertB64)) {
                $installParams += "P_CERT_AUTH_PATH=`"$caPath`""
            }

            if (-not [string]::IsNullOrEmpty($productUuid)) {
                $installParams += "P_CMD_PRODUCT_GUID=`"$productUuid`""
            }

            Start-Process -FilePath "msiexec.exe" -ArgumentList $installParams -Verb 'runas' #-WindowStyle Hidden  
        }
        else {
            Write-Error "Downloaded Package Hash Mismatch - Expected '$checksum' but got '$downloadedHash'"
        }
    }
}