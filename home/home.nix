{ ... }:
{
  imports = [
    ./cli
    ./gui
    ./fcitx5
    ./desktop
    ./emulator
  ];
  # Define the user for whom to manage the home directory
  home.username = "rum";
  home.homeDirectory = "/home/rum";

  # Define Envs
  home.sessionVariables = {
    EDITOR = "nano";
  };

  # Change in each release
  home.stateVersion = "26.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
