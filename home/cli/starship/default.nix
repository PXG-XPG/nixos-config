{ ... }: 
{
  programs.starship = {
    enable = true;
  };

  home.file.".config" = {
    source = ./presets;
    recursive = true;
  };
}
