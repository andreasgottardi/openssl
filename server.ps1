[CmdletBinding()]
param (

	[Parameter()]
	[string]
	$OpenSSL = "openssl.exe",

	[Parameter()]
	[string]
	$ServerName = "server1",

	# Parameter help description
	[Parameter()]
	[string[]]
	$DnsAltNames = @("localhost"),

	# Parameter help description
	[Parameter()]
	[string[]]
	$DnsAltIPs = @("127.0.0.1", "::1")
)

$CertDir = "certs"

if(-Not (Test-Path "${CertDir}\${ServerName}")){
	
	New-Item -ItemType "Directory" -Path "${CertDir}\${ServerName}"
	Set-Content -Path "${CertDir}\${ServerName}\${ServerName}.cnf" -Value "[req]"
	Add-Content -Path "${CertDir}\${ServerName}\${ServerName}.cnf" -Value "distinguished_name = req_distinguished_name"
	Add-Content -Path "${CertDir}\${ServerName}\${ServerName}.cnf" -Value "req_extensions = v3_req"
	Add-Content -Path "${CertDir}\${ServerName}\${ServerName}.cnf" -Value "prompt = no"
	Add-Content -Path "${CertDir}\${ServerName}\${ServerName}.cnf" -Value "[req_distinguished_name]"
	Add-Content -Path "${CertDir}\${ServerName}\${ServerName}.cnf" -Value "C = AT"
	Add-Content -Path "${CertDir}\${ServerName}\${ServerName}.cnf" -Value "ST = Vorarlberg"
	Add-Content -Path "${CertDir}\${ServerName}\${ServerName}.cnf" -Value "L = Dornbirn"
	Add-Content -Path "${CertDir}\${ServerName}\${ServerName}.cnf" -Value "O = Goa Systems"
	Add-Content -Path "${CertDir}\${ServerName}\${ServerName}.cnf" -Value "OU = IT department"
	Add-Content -Path "${CertDir}\${ServerName}\${ServerName}.cnf" -Value "CN = ${ServerName}"
	Add-Content -Path "${CertDir}\${ServerName}\${ServerName}.cnf" -Value "emailAddress = andreas.gottardi@goa.systems"
	Add-Content -Path "${CertDir}\${ServerName}\${ServerName}.cnf" -Value "[v3_req]"
	Add-Content -Path "${CertDir}\${ServerName}\${ServerName}.cnf" -Value "keyUsage = keyEncipherment, dataEncipherment"
	Add-Content -Path "${CertDir}\${ServerName}\${ServerName}.cnf" -Value "extendedKeyUsage = serverAuth"
	Add-Content -Path "${CertDir}\${ServerName}\${ServerName}.cnf" -Value "subjectAltName = @alt_names"
	Add-Content -Path "${CertDir}\${ServerName}\${ServerName}.cnf" -Value "[alt_names]"

	for ($i = 0; $i -lt $DnsAltNames.Count; $i++) {
		Add-Content -Path "${CertDir}\${ServerName}\${ServerName}.cnf" -Value "DNS.$($i + 1) = $($DnsAltNames[$i])"
	}

	for ($i = 0; $i -lt $DnsAltIPs.Count; $i++) {
		Add-Content -Path "${CertDir}\${ServerName}\${ServerName}.cnf" -Value "IP.$($i + 1)  = $($DnsAltIPs[$i])"
	}

	<#
		The following two lines create a certificate signing request.
	#>
	& $OpenSSL genrsa -out "${CertDir}\${ServerName}\${ServerName}.key" 4096
	& $OpenSSL req -new -out "${CertDir}\${ServerName}\${ServerName}.csr" -key "${CertDir}\${ServerName}\${ServerName}.key" -config "${CertDir}\${ServerName}\${ServerName}.cnf"

	<#
		The following line signs the csr.
	#>
	& $OpenSSL ca -batch -config .\ca\rootca.cnf -out "${CertDir}\${ServerName}\${ServerName}.crt" -infiles "${CertDir}\${ServerName}\${ServerName}.csr"

	<#
		The following command generates a pfx file from the private key and certificate.
	#>
	& $OpenSSL pkcs12 -export -out "${CertDir}\${ServerName}\${ServerName}.pfx" -inkey "${CertDir}\${ServerName}\${ServerName}.key" -in "${CertDir}\${ServerName}\${ServerName}.crt" -password pass:$ServerName -name "$ServerName"
} else {
	Write-Host -Object "Certificate already exists."
}