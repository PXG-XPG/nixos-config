{ pkgs, commonAliases, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = commonAliases;
    plugins = [
      {
        name = "autopair";
        inherit (pkgs.fishPlugins.autopair) src;
      }
    ];
    shellInit = ''
      fastfetch
      set -x STARSHIP_CONFIG ~/.config/gruvbox-rainbow.toml
      set fish_greeting ""
    '';
  };
}
