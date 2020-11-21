$FileName = [io.path]::GetFileName("$($args[0])")

# Block Executable from Running
if ($args[1] -like 'BlockExecutable') {
$Path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$($FileName)"; if(-not (Test-Path -LiteralPath $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -LiteralPath $Path -Name "Debugger" -PropertyType String -Value "%windir%\System32\systray.exe" -Force
Exit
}

if ($args[1] -like 'UnblockExecutable') {
Remove-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$($FileName)" -Name Debugger -Force -Confirm:$False
Exit
}

# Per Executable Mitigation Options
if ($args[1] -like 'EnableMitigations') {
$Path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$($FileName)"; if(-not (Test-Path -LiteralPath $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -LiteralPath $Path -Name "MitigationOptions" -PropertyType Binary -Value ([byte[]](0x11,0x11,0x11,0x00,0x00,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00)) -Force
Exit
}

if ($args[1] -like 'DisableMitigations') {
$Path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$($FileName)"; if(-not (Test-Path -LiteralPath $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -LiteralPath $Path -Name "MitigationOptions" -PropertyType Binary -Value ([byte[]](0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00)) -Force
Exit
}

if ($args[1] -like 'DisableMitigationsIncludingDEP') {
$Path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$($FileName)"; if(-not (Test-Path -LiteralPath $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -LiteralPath $Path -Name "MitigationOptions" -PropertyType Binary -Value ([byte[]](0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00)) -Force
Exit
}

# Per Executable Large Pages
if ($args[1] -like 'EnableLargePages') {
$Path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$($FileName)"; if(-not (Test-Path -LiteralPath $Path)){ New-Item -ItemType String -Path $Path }
New-ItemProperty -LiteralPath $Path -Name "UseLargePages" -PropertyType Dword -Value 1 -Force
Exit
}

if ($args[1] -like 'DisableLargePages') {
Remove-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$($FileName)" -Name UseLargePages -Force -Confirm:$False
Exit
}

# Firewall Rules
# First Check if Exploit Mitigation Policy has been set on executable, otherwise abort.
$Path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$($FileName)"; if (!(Get-ItemProperty -Path $Path -name MitigationOptions -ea SilentlyContinue )) {
    Write-Host "Executable Security Policy not set!" -ForegroundColor Red
    Sleep 5
    Exit
    }

if ($args[1] -like 'AllowOutboundInternetTCPPort80'){ New-NetFirewallRule -DisplayName "Allow Internet: $FileName" -Program $args[0] -Direction Out -Protocol TCP -RemotePort 80 -RemoteAddress Any -Action Allow }
if ($args[1] -like 'AllowOutboundInternetTCPPort443'){ New-NetFirewallRule -DisplayName "Allow Internet: $FileName" -Program $args[0] -Direction Out -Protocol TCP -RemotePort 443 -RemoteAddress Any -Action Allow }
if ($args[1] -like 'AllowOutboundInternetAll'){ New-NetFirewallRule -DisplayName "Allow Internet: $FileName" -Program $args[0] -Direction Out -Protocol Any -RemoteAddress Any -Action Allow }
if ($args[1] -like 'AllowOutboundInternetAllUDP'){ New-NetFirewallRule -DisplayName "Allow Internet: $FileName" -Program $args[0] -Direction Out -Protocol UDP -RemoteAddress Any -Action Allow }
if ($args[1] -like 'AllowOutboundInternetAllTCP'){ New-NetFirewallRule -DisplayName "Allow Internet: $FileName" -Program $args[0] -Direction Out -Protocol TCP -RemoteAddress Any -Action Allow }
if ($args[1] -like 'AllowOutboundLocalAllTCP'){ New-NetFirewallRule -DisplayName "Allow Local: $FileName" -Program $args[0] -Direction Out -Protocol TCP -RemoteAddress LocalSubnet -Action Allow }
if ($args[1] -like 'AllowInboundLocalAllTCP'){ New-NetFirewallRule -DisplayName "Allow Local: $FileName" -Program $args[0] -Direction In -Protocol TCP -RemoteAddress LocalSubnet -Action Allow }
if ($args[1] -like 'AllowInboundLocalAll'){ New-NetFirewallRule -DisplayName "Allow Local: $FileName" -Program $args[0] -Direction In -Protocol Any -RemoteAddress LocalSubnet -Action Allow }
if ($args[1] -like 'AllowOutboundLocalAll'){ New-NetFirewallRule -DisplayName "Allow Local: $FileName" -Program $args[0] -Direction Out -Protocol Any -RemoteAddress LocalSubnet -Action Allow }
if ($args[1] -like 'AllowInboundInternetAll'){ New-NetFirewallRule -DisplayName "Allow Internet: $FileName" -Program $args[0] -Direction In -Protocol Any -RemoteAddress Any -Action Allow }
if ($args[1] -like 'CustomFirewallRule'){
Write-Host "(Can leave Port/Address blank for 'Any')" -ForegroundColor DarkGreen
Write-Host "Firewall Rule Name" -ForegroundColor Green
$DisplayName = Read-Host "Name"
Write-Host "Firewall Rule Direction" -ForegroundColor Green
$Direction = Read-Host "Inbound or Outbound"
Write-Host "Firewall Rule Protocol" -ForegroundColor Green
$Protocol = Read-Host "Protocol"
Write-Host "Firewall Rule Remote Port" -ForegroundColor Green
$RemotePort = Read-Host "Remote Port"
Write-Host "Firewall Rule Local Port" -ForegroundColor Green
$LocalPort = Read-Host "Local Port"
Write-Host "Firewall Rule Remote Address (Any, LocalSubnet, Internet, Specific)" -ForegroundColor Green
$RemoteAddress = Read-Host "Remote Address"
Write-Host "Firewall Rule Local Address (Any, LocalSubnet, Internet, Specific)" -ForegroundColor Green
$LocalAddress = Read-Host "Local Address"
Write-Host "Firewall Rule Temporary? (Leave Empty for Permanent)" -ForegroundColor Green
$Temporary = Read-Host "Temporary"
if($Temporary -ne "") {
    Write-Host "Firewall Rule Temporary Minutes?" -ForegroundColor Green
    $TemporaryMinutes = Read-Host "Temporary Minutes"
    $Temp = " (Temporary)"
    Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -WindowStyle Hidden -NoLogo -NonInteractive -File C:\Windows\Scripts\TemporaryFirewallRule.ps1 -Param1 $TemporaryMinutes"
    }

if ($RemotePort -eq ''){ $RemotePort = 'Any' } 
if ($LocalPort -eq ''){ $LocalPort = 'Any' }
if ($RemoteAddress -eq ''){ $RemoteAddress = 'Any' }
if ($LocalAddress -eq ''){ $LocalAddress = 'Any' }

New-NetFirewallRule -DisplayName "Allow Custom: $DisplayName$Temp" -Program $args[0] -Direction $Direction -Protocol $Protocol -RemotePort $RemotePort -LocalPort $LocalPort `
 -RemoteAddress $RemoteAddress -LocalAddress $LocalAddress -Action Allow

if($?)
    {
    Write-Host "Rule Successfully Created." -ForegroundColor Green
    Sleep -Seconds 3
    Exit
    }
else
    {
    Write-Host "Failed to Create Rule!" -ForegroundColor Red
    Read-Host “Press ENTER to continue...”
    Exit
    }
}