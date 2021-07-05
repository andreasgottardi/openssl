<#
    This script removes all generated files and resets the certification authoroty.
#>

Remove-Item -Path @("*.crt", "*.csr", "*.pem", "*.key", "ca\*.old", "ca\*.attr", "ca\certs\*.pem", "ca\rootca.crt", "ca\rootca.key", "certs") -ErrorAction SilentlyContinue -Recurse
Set-Content -Path "ca\ca.db.index" -Value "" -NoNewline
Set-Content -Path "ca\ca.db.serial" -Value "01"