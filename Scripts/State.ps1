Get-EventSubscriber | Unregister-Event

$objUser = New-Object System.Security.Principal.NTAccount("Administrator")
$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
$strSID.Value


# Monitor Power State Changes (Razer)
$model = (gwmi Win32_ComputerSystem).Model; if ( $model -like 'Blade Stealth 13 (Early 2020) - RZ09-0310') {
    Register-WmiEvent -Query 'Select * From Win32_PowerManagementEvent within 5' -SourceIdentifier 'Power' -Action {
        If ([bool](Get-WmiObject -Class BatteryStatus -Namespace root\wmi).PowerOnLine) {
    
    	if (Get-Process "AutoHotkey" -ErrorAction silentlycontinue) {
    	   	"Do Nothing"
    	   	}
    	else
    	   	{
    	   	Start-Process -NoNewWindow -LoadUserProfile -FilePath "C:\Program Files\AutoHotkey\AutoHotKey.exe" -ArgumentList "C:\Users\Administrator\Desktop\MTHaxTool\mthaxtool-systemwide_module.ahk" -WorkingDirectory "C:\Users\Administrator\Desktop\MTHaxTool"
    	   	}
    
    
        } else {
    
            Stop-Process -processname 'AutoHotkey' -Force
        }
    }
}


# Monitor Registry Changes
$wmiEvent = "SELECT * FROM RegistryTreeChangeEvent within 5 WHERE " + " Hive = 'HKEY_USERS' " +
                 "AND RootPath = '$($strSID.Value)\\Software\\Microsoft\\Windows\\CurrentVersion\\Run\\'"

Register-WmiEvent -Query $wmiEvent -SourceIdentifier myKeyListener -Action { 
    write-host "yes"; Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "*" -Confirm:$False
    }


# Monitor Firewall Changes
$query = "SELECT * FROM __instanceCreationEvent within 2 WHERE TargetInstance ISA 'Win32_NTLogEvent' AND TargetInstance.EventCode=2004"
Register-WMIEvent -Query $query -SourceIdentifier Firewall -Action { 
    Get-NetFirewallRule | Where { $_.DisplayName -notmatch 'Script Generated' -and $_.DisplayName -notmatch 'Allow' } | Remove-NetFirewallRule
    }