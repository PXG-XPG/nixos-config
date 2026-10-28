#!/usr/bin/env bash
set -euo pipefail

HOSTNAME="nixos"
DISKO_CONFIG="./disko/disko-config.nix"
DISK="/dev/nvme1n1"

if [[ ! -b "$DISK" ]]; then
    echo "ERROR: $DISK is not a block device"
    exit 1
fi

if findmnt -rn -S "$DISK" >/dev/null 2>&1; then
    echo "ERROR: $DISK is currently in use (mounted). Unmount it first."
    exit 1
fi

echo "WARNING: This script will completely erase $DISK and install NixOS to $HOSTNAME"
echo "Disk: $DISK"
echo "Hostname: $HOSTNAME"
read -p "Confirm details? Type 'yes' to continue: " confirm
if [[ "$confirm" != "yes" ]]; then
    echo "Installation cancelled"
    exit 1
fi

# 清理挂载与 swap
sudo umount -R /mnt 2>/dev/null || true
sudo swapoff -a 2>/dev/null || true

# 彻底清空目标盘签名与分区表
sudo wipefs -a "$DISK"
sudo sgdisk --zap-all "$DISK" 2>/dev/null || true

echo "=== 1. Partitioning, Formatting, and Mounting (disko) ==="
sudo nix --experimental-features "nix-command flakes" \
    run github:nix-community/disko/latest -- \
    --mode destroy,format,mount \
    "$DISKO_CONFIG" \
    --arg disk "{ main = \"$DISK\"; }"

# 复制仓库配置（不复制隐藏文件，避免带入 .git）
sudo mkdir -p /mnt/etc/nixos
sudo cp -rf ./* /mnt/etc/nixos

# 删除可能随仓库带来的旧 hardware-configuration.nix，重新生成
sudo rm -f /mnt/etc/nixos/hardware-configuration.nix

echo "=== 2. Generating hardware-configuration.nix ==="
sudo nixos-generate-config --no-filesystems --root /mnt

echo "=== 3. Executing nixos-install ==="
sudo nixos-install --flake "/mnt/etc/nixos#$HOSTNAME" --no-root-password

echo "=== Installation Complete! ==="
echo "Please enter the system to set passwords for your normal user and root"
echo "After setting passwords, please shut down and reboot the system"
