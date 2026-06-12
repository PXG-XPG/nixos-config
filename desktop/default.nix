{ config, ... }:
{
  imports = [
    ./windowing.nix
    ./gaming.nix
    ./dms-niri
  ];

  environment.systemPackages = [
    config.home-manager.users.rum.gtk.iconTheme.package
  ];
}
