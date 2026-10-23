{ config, pkgs, ... }:
{
  home.packages = [ pkgs.wezterm ];

  home.file.".config/wezterm" = {
    source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/emulator/wezterm/wezterm";
  };
}
