$OpenSSL = "openssl.exe"

<#
	The following three lines generate the root certificate and key. This is then used to sign server and client certificates.
	The file "rootca.key" has to be kept private.
	The file "rootca.pem" has to be distributed to the systems that should accept certificates signed with the private key.
#>
& $OpenSSL genrsa -out rootca.key 4096
& $OpenSSL req -x509 -sha512 -new -config rootca.cnf -nodes -key rootca.key -days 3650 -out rootca.pem
& $OpenSSL x509 -in rootca.pem -noout -text

<#
	The following two lines create a certificate signing request.
#>
& $OpenSSL genrsa -out server1.key 4096
& $OpenSSL req -new -out server1.csr -key server1.key -config server1.cnf

<#
	The following line signs the csr.
#>
& $OpenSSL ca -config rootca.cnf -out server1.crt -infiles server1.csr