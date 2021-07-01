$OpenSSL = "openssl.exe"

& $OpenSSL genrsa -out rootca.key 4096
& $OpenSSL req -x509 -sha512 -new -config generate.cnf -nodes -key rootca.key -days 3650 -out rootca.pem
& $OpenSSL x509 -in rootca.pem -noout -text