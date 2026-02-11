{ ... }:

{
  imports = [
    ./bootloader.nix
    ./kernel.nix
    ./zramSwap.nix
    ./i18n.nix
    ./networking.nix
    ./nvidia.nix
    ./bluetooth.nix
    ./fonts.nix
    ./nix-ld.nix
    ./flatpak.nix
    ./sound.nix
    ./packages.nix
  ];
}
