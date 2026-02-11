{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    shellAliases = {
      mv = "mv -i";
      cp = "cp -i";
      cls = "clear";
      grep = "grep --color=auto";
      ff = "fastfetch";
      ffall = "fastfetch -c all";
      ".." = "cd ..";
      "..." = "cd ../..";
    };
    shellInit = ''
      fastfetch
      set -x STARSHIP_CONFIG ~/.config/gruvbox-rainbow.toml
      set fish_greeting ""
    '';
  };
}
