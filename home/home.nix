{ username, homeDirectory, ... }:
{
  imports = [
    ./cli
    ./gui
    ./fcitx5
    ./desktop
    ./emulator
  ];
  # Define the user for whom to manage the home directory
  home.username = username;
  home.homeDirectory = homeDirectory;

  # Define Envs
  home.sessionVariables = {
    EDITOR = "nvim";
    GSK_RENDERER = "gl"; # To solve "GTK 4 applications are slow"
  };

  # Change in each release
  home.stateVersion = "26.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
