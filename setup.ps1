#requires -RunAsAdministrator

Write-Host "=============================================="
Write-Host "     ShellRemoteAdmin Windows Target Setup"
Write-Host "=============================================="
Write-Host ""

Write-Host "[*] Installing OpenSSH Server..."

Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

Write-Host "[*] Starting SSH service..."

Start-Service sshd

Set-Service -Name sshd -StartupType Automatic

Write-Host "[*] Configuring Windows Firewall..."

if (-not (Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue)) {

    New-NetFirewallRule `
        -Name "OpenSSH-Server-In-TCP" `
        -DisplayName "OpenSSH Server (TCP 22)" `
        -Enabled True `
        -Direction Inbound `
        -Protocol TCP `
        -Action Allow `
        -LocalPort 22
}

Write-Host ""
Write-Host "[+] OpenSSH Server is enabled."

Write-Host ""
Write-Host "Computer:"
hostname

Write-Host ""
Write-Host "IPv4 addresses:"

Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object {
        $_.IPAddress -notlike "127.*" -and
        $_.IPAddress -notlike "169.254.*"
    } |
    Select-Object IPAddress,InterfaceAlias

Write-Host ""
Write-Host "=============================================="
Write-Host " Windows target setup completed"
Write-Host "=============================================="
