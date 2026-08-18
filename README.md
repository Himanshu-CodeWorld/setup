# ShellRemoteAdmin Target Setup

ShellRemoteAdmin Target Setup is a small cross-platform setup utility for preparing a computer to be managed remotely over SSH.

The repository contains setup scripts for:

- Linux
- macOS
- Windows

> **Important:** Use these scripts only on computers you own or are explicitly authorized to administer.

## Features

### Linux

The `setup.sh` script can:

- Detect Linux
- Install OpenSSH Server
- Support common package managers (`apt`, `dnf`, `yum`, and `pacman`)
- Enable and start the SSH service
- Display local IP addresses
- Configure passwordless `systemctl reboot` and `systemctl poweroff` through a restricted sudoers rule

### macOS

The `setup.sh` script can:

- Enable macOS Remote Login (SSH)
- Display the target IP address

### Windows

The `setup.ps1` script can:

- Install the Windows OpenSSH Server capability
- Start and enable the `sshd` service
- Configure a Windows Firewall rule for TCP port 22
- Display the computer name and IPv4 addresses

## Project Structure

```text
.
├── setup.sh
├── setup.ps1
└── README.md
```

## Requirements

### Linux

- Linux system with a supported package manager
- Root/sudo access
- `systemd` for automatic SSH service management

### macOS

- macOS
- Administrator privileges

### Windows

- Windows with PowerShell
- Administrator privileges
- Internet access may be required to install the OpenSSH capability

## Installation

Clone the repository:

```bash
git clone <YOUR-GITHUB-REPOSITORY-URL>
cd <YOUR-REPOSITORY-NAME>
```

## Linux

Run:

```bash
sudo bash setup.sh
```

The script installs and enables OpenSSH Server and prints the machine's IP address.

After setup, you can verify SSH with:

```bash
systemctl status ssh
```

or:

```bash
systemctl status sshd
```

## macOS

Run:

```bash
sudo bash setup.sh
```

The script enables Remote Login and displays an available IP address.

You can verify SSH availability from another authorized computer with:

```bash
ssh username@TARGET_IP
```

## Windows

Open **PowerShell as Administrator**, navigate to the repository directory, and run:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\setup.ps1
```

The script installs OpenSSH Server, starts `sshd`, enables automatic startup, and creates a firewall rule for TCP port 22.

Check the SSH service with:

```powershell
Get-Service sshd
```

## Connecting Over SSH

After the target setup is complete, connect from another authorized computer:

```bash
ssh username@TARGET_IP
```

For Windows, use the appropriate Windows account:

```bash
ssh username@TARGET_IP
```

Replace:

- `username` with the target computer's account name
- `TARGET_IP` with the target computer's local or otherwise reachable IP address

## Security Notes

SSH provides remote access to the target computer, so secure configuration is important.

Recommended practices:

1. Use SSH keys instead of passwords where practical.
2. Do not expose port 22 directly to the public internet unless you understand and secure the risks.
3. Use a firewall and restrict access to trusted networks.
4. Keep the operating system and OpenSSH packages updated.
5. Use a strong account password.
6. Review SSH configuration before deploying to production systems.
7. Only administer systems for which you have permission.

### Linux Power Management Permission

On Linux, the script creates:

```text
/etc/sudoers.d/shellremoteadmin
```

with a restricted rule allowing the selected user to execute:

```text
/usr/bin/systemctl reboot
/usr/bin/systemctl poweroff
```

without entering a sudo password.

This permission is intentionally limited to those two commands. Review the generated sudoers file before using the setup on sensitive systems.

## Troubleshooting

### SSH service is not running

Linux:

```bash
systemctl status ssh
```

or:

```bash
systemctl status sshd
```

Windows:

```powershell
Get-Service sshd
```

### Check the target IP

Linux:

```bash
hostname -I
```

macOS:

```bash
ifconfig
```

Windows:

```powershell
Get-NetIPAddress -AddressFamily IPv4
```

### Test the SSH port

From another authorized machine:

```bash
ssh username@TARGET_IP
```

If the connection fails, check:

- The target computer is powered on.
- Both devices can reach each other.
- SSH is running.
- The firewall allows SSH.
- The username is correct.
- Port 22 is reachable on the target network.

## License

Add your preferred open-source license before publishing this repository.

## Disclaimer

This project is intended for legitimate system administration, development, testing, and educational use. The author is not responsible for unauthorized access, misuse, damage, or loss resulting from use of these scripts.
