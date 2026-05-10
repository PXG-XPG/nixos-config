# Install nixos

## switch to root
```
sudo -i
```

## confirm which disk you want to use
```
lsblk
```

# pull my nixos-config and exec install script
```
git clone https://github.com/PXG-XPG/nixos-config.git
./install.sh
```
## set password after installation
```
nixos-enter --root /mnt
passwd rum
passwd root
```
