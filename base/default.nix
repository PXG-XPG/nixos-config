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
    ./fonts.nix
    ./nix-ld.nix
    #./flatpak.nix
    ./sound.nix
    ./packages.nix
    ./shell.nix
    ./editor
  ];
}
