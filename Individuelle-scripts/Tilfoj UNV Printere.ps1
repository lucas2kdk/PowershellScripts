Write-Host "Tilføjer farve"
Add-Printer -ConnectionName "\\uprint03\HBUNV-(FARVE)"

Write-Host "Tilføjer Sort"
Add-Printer -ConnectionName "\\uprint03\HBUNV-(SORT)"

Write-Host('Tryk enter for at forsætte') -Fore Green
Read-Host