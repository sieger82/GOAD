param ([String] $IPAdres)

# disable ipv6 transition modes
Set-NetTeredoConfiguration -Type Disabled
Set-Net6to4Configuration -State Disabled
Set-NetIsatapConfiguration -State Disabled

# Get the right Ethernet adapter
$Adapter = Get-NetAdapter -Physical | Get-NetIPInterface -AddressFamily IPv4 | 
    Where-Object { $_.InterfaceAlias -like "*Ethernet*" } | Get-DnsClient | 
    Where-Object { $_.ConnectionSpecificSuffix -ne "mshome.net" } | 
    Select-Object -First 1

# Set the IP
if ($Adapter) {
    Remove-NetIPAddress -InterfaceAlias $Adapter.InterfaceAlias -AddressFamily IPv4 -Confirm:$false -ErrorAction SilentlyContinue
    New-NetIPAddress -InterfaceAlias $Adapter.InterfaceAlias -IPAddress $IPAdres -PrefixLength 24 
}
