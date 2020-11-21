# Commands to execute once after login
stop-dtc -Confirm:$False
Remove-NetFirewallRule -DisplayName '*(Temporary)*'
Start-Process -FilePath 'C:\Program Files\Iconoid\iconoid64.exe' -WorkingDirectory 'C:\Program Files\Iconoid' -WindowStyle Minimized