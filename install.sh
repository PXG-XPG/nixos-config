#!/usr/bin/env bash
set -euo pipefail

# === Configuration === #
# Your flake name (the key in nixosConfigurations)
HOSTNAME="nixos"

# Relative path to the disko configuration file (relative to repo root)
DISKO_CONFIG="./disko/disko-config.nix"

# Target disk (WILL BE FULLY ERASED! Ensure this is correct)
# For physical machines, usually /dev/nvme0n1 or /dev/sda
# For virtual machine testing, usually /dev/vda
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
