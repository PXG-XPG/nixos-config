{ ... }:
{
  imports = [
    ./boot.nix
    ./zramSwap.nix
    ./i18n.nix
    ./keymap.nix
    ./networking.nix
    ./nvidia.nix
    ./bluetooth.nix
    ./font.nix
    ./sound.nix
    ./packages.nix
    ./user.nix
    ./flatpak.nix
    ./nix.nix
  ];
}
