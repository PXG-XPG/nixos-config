sudo -i

nmtui

cfdisk ...

mkfs.ext4 -L NIXOS ...

mkfs.fat -F 32 -n BOOT ...

mount ... /mnt

mount --mkdir ... /mnt/boot

nixos-generate-config --root /mnt

cp -r ./* /mnt/etc/nixos

nixos-install --flake "/mnt/etc/nixos#nixos" --no-root-password
