{ ... }:

{
  imports = [
    ./editors
    ./terminalApps
    ./desktopApps
    ./fcitx5
    ./appimageRun
    ./virtualisation
    ./desktopEnvironment
  ];
  # Define the user for whom to manage the home directory
  home.username = "rum";
  home.homeDirectory = "/home/rum";

  # Change in each release
  home.stateVersion = "26.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
