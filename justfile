default:
  @just --list --unsorted

# Sync configuration from github
sync:
  @sudo git pull

# Build but not activate
build:
  @nh os boot
  @echo "Reboot to apply new configuration!"

# Clean all Old generations and gc
clean:
  @sudo nix-collect-garbage --delete-old
  @nix-collect-garbage --delete-old
