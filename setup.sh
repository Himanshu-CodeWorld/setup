#!/usr/bin/env bash

set -e

echo "=============================================="
echo "      ShellRemoteAdmin Target Setup"
echo "=============================================="
echo

OS="$(uname -s)"

if [ "$OS" = "Linux" ]; then

    echo "[*] Linux detected."

    if [ "$EUID" -ne 0 ]; then
        echo "[!] Please run:"
        echo "    sudo bash setup.sh"
        exit 1
    fi

    echo "[*] Updating packages..."
    apt update

    echo "[*] Installing OpenSSH Server..."

    if command -v apt >/dev/null 2>&1; then
        apt install -y openssh-server
    elif command -v dnf >/dev/null 2>&1; then
        dnf install -y openssh-server
    elif command -v yum >/dev/null 2>&1; then
        yum install -y openssh-server
    elif command -v pacman >/dev/null 2>&1; then
        pacman -Sy --noconfirm openssh
    else
        echo "[!] Unsupported Linux package manager."
        exit 1
    fi

    echo "[*] Enabling SSH..."

    systemctl enable --now ssh 2>/dev/null || \
    systemctl enable --now sshd

    echo
    echo "[+] SSH server is running."

    echo
    echo "SSH service:"
    systemctl is-active ssh 2>/dev/null || \
    systemctl is-active sshd

    echo
    echo "Target IP addresses:"
    hostname -I 2>/dev/null || ip addr

    echo
    echo "[*] Configuring passwordless power management..."

    USER_NAME="${SUDO_USER:-$USER}"

    SUDOERS_FILE="/etc/sudoers.d/shellremoteadmin"

    cat > "$SUDOERS_FILE" <<EOF
$USER_NAME ALL=(root) NOPASSWD: /usr/bin/systemctl reboot, /usr/bin/systemctl poweroff
EOF

    chmod 440 "$SUDOERS_FILE"

    if command -v visudo >/dev/null 2>&1; then
        visudo -cf "$SUDOERS_FILE"
    fi

    echo
    echo "[+] Passwordless reboot/shutdown configured."

    echo
    echo "Test:"
    echo "  sudo -n systemctl reboot"
    echo "  sudo -n systemctl poweroff"

    echo
    echo "=============================================="
    echo " Target setup completed"
    echo "=============================================="

elif [ "$OS" = "Darwin" ]; then

    echo "[*] macOS detected."

    echo
    echo "[*] Enabling Remote Login (SSH)..."

    sudo systemsetup -setremotelogin on

    echo
    echo "[+] SSH Remote Login enabled."

    echo
    echo "Target IP:"
    ipconfig getifaddr en0 2>/dev/null || \
    ipconfig getifaddr en1 2>/dev/null || \
    echo "Use: ifconfig"

    echo
    echo "=============================================="
    echo " macOS target setup completed"
    echo "=============================================="

else

    echo "[!] Unsupported operating system: $OS"
    exit 1
fi
