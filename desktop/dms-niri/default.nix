{ pkgs, config, ... }:
{
  imports = [
    ../polkit-gnome.nix
    ../gnome-keyring.nix
    ../xdg-desktop-portal.nix
    ../nautilus.nix
    ./niri
    ./dms
  ];

  environment.systemPackages = with pkgs; [
    accountsservice
    xwayland-satellite
    adw-gtk3
    kdePackages.qt6ct
    i2c-tools
    wl-clipboard
  ];
}
