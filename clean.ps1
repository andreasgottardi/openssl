<#
    This script removes all generated files and resets the certification authoroty.
#>

Remove-Item -Path @("*.crt", "*.csr", "*.pem", "*.key", "ca\*.old", "ca\*.attr", "ca\certs\*.pem")
Set-Content -Path "ca\ca.db.index" -Value "" -NoNewline
Set-Content -Path "ca\ca.db.serial" -Value "01"