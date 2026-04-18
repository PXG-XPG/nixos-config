{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
  };

  imports = [
    ./opts.nix
    ./globals.nix
    ./colorscheme.nix
    ./plugins
    ./extra-plugins.nix
    ./keymaps.nix
    ./extra-config.nix
  ];
}
