<#
.DESCRIPTION
This script implements security best practices used in the IT-Box project. It reduces attack surface, enables advanced auditing, and removes insecure protocol
#>

Write-Host "Starting Windows Server Hardening..." -ForegroundColor Cyan
# SMBv1 is a vulnerable protocol exploited by ransomware like WannaCry.
Write-Host "[*] Disabling SMBv1 Protocol..."
Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart
# Removing XPS Viewer to reduce potential exploit vectors.
Write-Host "[*] Removing XPS Viewer..."
Get-WindowsFeature -Name XPS-Viewer | Uninstall-WindowsFeature -Restart:$false
# Note: Sometimes GPO settings usually fail to apply locally, so we have to force them via auditpol.
Write-Host "[*] Enforcing Advanced Audit Policies..."
# Track Logons (Success and Failure) to detect brute-force attempts
auditpol /set /category:"Logon/Logoff" /success:enable /failure:enable
# Track Privilege Use to see when Admin rights are being used
auditpol /set /category:"Privilege Use" /success:enable /failure:enable
# Track File Access (Failure) to see unauthorized access attempts
auditpol /set /category:"Object Access" /failure:enable
# Force Group Policy Update to ensure settings stick
Write-Host "[*] Forcing group policy update..."
Gpupdate /force
# Verifying the Policy
auditpol /get /category:"Logon/Logoff"
# Command to identify inactive accounts (security risk)
Write-Host "[*] Scanning for inactive accounts (>90 days)..."
Search-ADAccount -AccountInactive -TimeSpan 90.00:00:00 -UsersOnly
Write-Host "Hardening Configuration Complete." -ForegroundColor Green
