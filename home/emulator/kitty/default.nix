{ config, pkgs, ... }:
{
  home.packages = [ pkgs.kitty ];

  home.file.".config/kitty" = {
    source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/emulator/kitty/kitty";
  };
}
