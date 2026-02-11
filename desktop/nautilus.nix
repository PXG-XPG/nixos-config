{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nautilus
    loupe
  ];

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "kitty";
  };

  services.gnome.sushi.enable = true;
  services.gvfs.enable = true;
}
