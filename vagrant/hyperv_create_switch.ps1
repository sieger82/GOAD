param ([String] $ip_range)

# This vswitch will be automaticaly created by this script
try {
    Write-Host -ForegroundColor Yellow  "[+] Does GOAD_INTERNAL_$($ip_range) switch exist?"
    Get-VMSwitch -Name GOAD_INTERNAL_$ip_range -ErrorAction Stop | select -exp Name
    Write-Host -ForegroundColor Green  "[+] Yes!"
}
catch [Microsoft.HyperV.PowerShell.VirtualizationException] {
    Write-Host -ForegroundColor Red  "[+] No, creating the switch"
    New-VMSwitch -Name GOAD_INTERNAL_$ip_range -SwitchType Internal
    Write-Host "[+] Waiting for virtual network adapter to appear..."
    $adapter = $null
    while (-not $adapter) {
	    Start-Sleep -Seconds 2
	    $adapter = Get-NetAdapter -Name "*GOAD_INTERNAL_$($ip_range)*" -ErrorAction SilentlyContinue
	}
}

Write-Host "[+] Checking IP configuration"
$Adapter = Get-NetAdapter -Name "*GOAD_INTERNAL_$($ip_range)*" | Select-Object -First 1
$IpAddress = (Get-NetIPAddress -InterfaceAlias $Adapter.InterfaceAlias -AddressFamily IPv4 -ErrorAction SilentlyContinue).IPAddress 

if ($IpAddress -eq "$($ip_range).100") {
    Write-Host "[+] IP Address of virtual adapter is correct" -ForegroundColor Green
} else {
    Write-Host "[+] Setting IPAdress of virtual network adapter" -ForegroundColor Yellow
    Remove-NetIPAddress -InterfaceAlias $Adapter.InterfaceAlias -AddressFamily IPv4 -Confirm:$false -ErrorAction SilentlyContinue
    New-NetIPAddress -InterfaceAlias $Adapter.InterfaceAlias -IPAddress "$($ip_range).100" -PrefixLength 24
}