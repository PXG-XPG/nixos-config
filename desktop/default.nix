{ config, ... }:
{
  imports = [
    ./windowing.nix
    ./gaming.nix
    ./dms-niri
    ./fancontrol.nix
  ];

  environment.systemPackages = [
    config.home-manager.users.rum.gtk.iconTheme.package
  ];
}
