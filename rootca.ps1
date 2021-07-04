[CmdletBinding()]
param (
	[Parameter()]
	[String]
	$OpenSSL = "openssl.exe"
)

<#
	The following three lines generate the root certificate and key. This is then used to sign server and client certificates.
	The file "rootca.key" has to be kept private.
	The file "rootca.pem" has to be distributed to the systems that should accept certificates signed with the private key.
#>
& $OpenSSL genrsa -out .\ca\rootca.key 4096
& $OpenSSL req -x509 -sha512 -new -config .\ca\rootca.cnf -nodes -key .\ca\rootca.key -days 3650 -out .\ca\rootca.crt
& $OpenSSL x509 -in .\ca\rootca.crt -noout -text