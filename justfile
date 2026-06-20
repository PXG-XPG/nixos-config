default:
  @just --list --unsorted

# Update flake.lock
update:
  @sudo nix flake update

# Build but not activate
build:
  nh os boot
  @echo "Reboot to apply new configuration!"

# Clean all Old generations and gc
clean:
  @sudo nix-collect-garbage --delete-old
  @nix-collect-garbage --delete-old
