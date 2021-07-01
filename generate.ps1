$OpenSSL = "openssl.exe"

<#
  This generates the root certificate.
  The file "rootca.key" has to be kept private.
  The file "rootca.pem" has to be distributed to the systems that should accept certificates signed with the private key.
#>
& $OpenSSL genrsa -out rootca.key 4096
& $OpenSSL req -x509 -sha512 -new -config rootca.cnf -nodes -key rootca.key -days 3650 -out rootca.pem
& $OpenSSL x509 -in rootca.pem -noout -text