# Auto Installation
# Install nixos through ssh

## switch to root
sudo -i

## set root password for ssh
passwd

## connect to network
nmtui

## check your IP
ip a

## confirm which disk you want to use,
lsblk

# ssh
ssh root@IP

# pull my nixos-config and exec install script
git clone https://github.com/PXG-XPG/nixos-config.git
./install.sh

## set password after installation
nixos-enter --root /mnt
passwd rum
passwd root
