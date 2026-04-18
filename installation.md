# Manual Installation

## switch to root
sudo -i

## connect to network
nmtui

## confirm which disk you want to use,
lsblk

## partition /dev/nvme1n1, for example
cfdisk /dev/nvme1n1
  1G     EFI System        /dev/nvme1n1p1
  other  Linux filesystem  /dev/nvme1n1p2

# format and mount
mkfs.ext4 -L NIXOS /dev/nvme1n1p2
mkfs.fat -F 32 -n BOOT /dev/nvme1n1p1
mount /dev/nvme1n1p2 /mnt
mount --mkdir /dev/nvme1n1p1 /mnt/boot

## check disk
lsblk -pf

## generate hardware-configuration.nix
## pull my config
nixos-generate-config --root /mnt
cd /mnt/etc/nixos
git clone https://github.com/PXG-XPG/nixos-config.git

## cp nixos-config
cd nixos-config
cp -r ./* /mnt/etc/nixos

## back to /root and install nixos
cd
nixos-install --flake "/mnt/etc/nixos#nixos" --no-root-password

## set password after installation
nixos-enter --root /mnt
passwd rum
passwd root
