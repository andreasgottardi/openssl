[CmdletBinding()]
param (
    [Parameter()]
    [String]
    $Certificate = "server1.crt"
)

$OpenSSL = "openssl.exe"
& $OpenSSL x509 -in $Certificate -noout -text