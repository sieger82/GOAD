param ([String] $ip_range)

Remove-VMSwitch -Name GOAD_INTERNAL_$ip_range -ErrorAction SilentlyContinue -Force -Confirm:$false