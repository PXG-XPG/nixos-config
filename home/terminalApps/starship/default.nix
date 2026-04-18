{ pkgs, ... }: 
{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };

  home.file.".config" = {
    source = ./presets;
    recursive = true;
  };
}
