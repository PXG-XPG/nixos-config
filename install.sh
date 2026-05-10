#!/usr/bin/env bash
set -euo pipefail

# === 配置区 === #
# 你的 flake 名称（nixosConfigurations 中的键）
HOSTNAME="nixos"

# disko 配置文件相对路径（相对于 repo 根目录）
DISKO_CONFIG="./disko/disko-config.nix"

# 目标磁盘（安装时会完全擦除！务必确认正确）
# 如果是物理机，通常是 /dev/nvme0n1 或 /dev/sda
# 如果是虚拟机测试，通常是 /dev/vda
DISK="/dev/nvme1n1"

echo "WARNING: This script will completely erase $DISK and install NixOS to $HOSTNAME"
echo "Disk: $DISK"
echo "Hostname: $HOSTNAME"
read -p "Confirm details? Type 'yes' to continue: " confirm
if [[ "$confirm" != "yes" ]]; then
    echo "Installation cancelled"
    exit 1
fi

echo "=== 1. Partitioning, Formatting, and Mounting (disko) ==="
sudo nix --experimental-features "nix-command flakes" \
    run github:nix-community/disko/latest -- \
    --mode destroy,format,mount \
    "$DISKO_CONFIG" \
    --arg disk "{ main = \"$DISK\"; }"

echo "=== 2. Generating hardware-configuration.nix ==="
sudo nixos-generate-config --no-filesystems --root /mnt

echo "=== 3. Copying entire configuration to target system ==="
sudo cp -r ./* /mnt/etc/nixos

echo "=== 4. Executing nixos-install ==="
sudo nixos-install --flake "/mnt/etc/nixos#$HOSTNAME" --no-root-password

echo "=== Installation Complete! ==="
echo "Please enter the system to set passwords for your normal user and root"
echo "After setting passwords, please shut down and reboot the system"
