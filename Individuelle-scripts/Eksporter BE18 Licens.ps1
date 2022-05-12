Write-Host "Hvor skal filen gemmes?"
$Path = Read-Host

Write-Host "Eksporterer regfil til C:\"
reg export "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Danish Building Research Institute\Be06" $Path\Be18Licens.reg

Write-Host('Tryk enter for at forsætte') -Fore Green
Read-Host