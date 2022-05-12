    Write-Host "Hvor skal rapporten gemmes?"
	$Path = Read-Host

	Write-Host "Genererer rapport"
	powercfg /batteryreport /output "$Path\BatteryReport.html"

    Write-Host('Tryk enter for at forsætte') -Fore Green
    Read-Host