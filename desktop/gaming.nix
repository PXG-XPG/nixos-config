{ pkgs, ... }:
{
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings.general.inhibit_screensaver = 0;
  };
  users.groups.gamemode.members = [ "rum" ];

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.steam = {
    enable = true;
    extest.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    extraPackages = with pkgs; [
      gamescope
    ];
    fontPackages = with pkgs; [
      source-han-sans
    ];
    protontricks.enable = true;
  };
}
