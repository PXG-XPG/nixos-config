{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nautilus
    loupe
    evince
  ];

  programs.nautilus-open-any-terminal = {
    enable = true;
  };

  services.gnome.sushi.enable = true;
  services.gvfs.enable = true;
}
