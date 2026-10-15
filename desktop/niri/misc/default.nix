{ ... }:
{
  imports = [
    ./gnome-keyring.nix
    ./polkit-gnome.nix
    ./nautilus.nix
    ./xwayland.nix
    ./xdg-portal.nix
  ];
}
