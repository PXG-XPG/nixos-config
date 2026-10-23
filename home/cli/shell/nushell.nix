{ config, commonAliases, ... }:
{
  programs.nushell = {
    enable = true;
    shellAliases = commonAliases;
    settings = {
      show_banner = false;
    };
    environmentVariables = {
      STARSHIP_CONFIG = "${config.home.homeDirectory}/.config/catppuccin-powerline.toml";
    };
    extraConfig = ''
      if ($env.NUSHELL_STARTED? == null) {
        fastfetch
        $env.NUSHELL_STARTED = "1"
      }
    '';
  };
}
