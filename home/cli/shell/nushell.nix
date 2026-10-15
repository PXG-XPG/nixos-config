{ pkgs, homeDirectory, commonAliases, ... }:
{
  programs.nushell = {
    enable = true;
    shellAliases = commonAliases;
    settings = {
      show_banner = false;
    };
    extraConfig = "
      fastfetch
    ";
    environmentVariables = {
      STARSHIP_CONFIG = "${homeDirectory}/.config/catppuccin-powerline.toml";
    };
  };
}
