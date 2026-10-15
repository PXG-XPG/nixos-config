{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nautilus
    libheif
    libheif.out
  ];

  environment.pathsToLink = [ "share/thumbnailers" ];

  programs.nautilus-open-any-terminal = {
    enable = true;
  };

  services.gnome.sushi.enable = true;
  services.gvfs.enable = true;
}
