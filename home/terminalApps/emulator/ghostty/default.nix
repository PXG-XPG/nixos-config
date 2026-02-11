{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
  };

  home.file.".config/ghostty" = {
    source = ./ghostty;
    recursive = true;
  };
}
