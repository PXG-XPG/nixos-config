#!/usr/bin/env bash
set -euo pipefail

# 确保相对路径基于脚本所在目录
cd "$(dirname "$0")"

# === Configuration === #
HOSTNAME="nixos"
DISKO_CONFIG="./disko/disko-config.nix"
DISK="/dev/nvme1n1"

# 校验目标盘存在
if [[ ! -b "$DISK" ]]; then
    echo "ERROR: $DISK is not a block device"
    exit 1
fi

# 校验目标盘及其分区未被挂载
if lsblk -ln -o MOUNTPOINT "$DISK" | grep -q .; then
    echo "ERROR: $DISK or its partitions are currently mounted. Unmount them first."
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

# 清理可能残留的挂载与 swap
sudo umount -R /mnt 2>/dev/null || true
sudo swapoff -a 2>/dev/null || true

# 彻底清空目标盘：移除文件系统签名 + 清空分区表
sudo wipefs -a "$DISK"
sudo sgdisk --zap-all "$DISK" 2>/dev/null || true
sudo partprobe "$DISK" 2>/dev/null || true

echo "=== 1. Partitioning, Formatting, and Mounting (disko) ==="
sudo nix --experimental-features "nix-command flakes" \
    run github:nix-community/disko/latest -- \
    --mode destroy,format,mount \
    "$DISKO_CONFIG" \
    --arg disk "{ main = \"$DISK\"; }"

# 可选：确认 destroy 已生效
if [[ -d /mnt/nix/store ]] && [[ -n "$(ls -A /mnt/nix/store 2>/dev/null)" ]]; then
    echo "WARNING: /mnt/nix/store is not empty; destroy may not have fully wiped the disk."
fi

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
