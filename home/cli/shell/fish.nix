{ pkgs, lib, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      su = "su -";
      mv = "mv -i";
      cp = "cp -i";
      cls = "clear";
      grep = "grep --color=auto";
      ff = "fastfetch";
      ffall = "fastfetch -c all";
      ".." = "cd ..";
      "..." = "cd ../..";
    };
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
