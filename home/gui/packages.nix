{ pkgs, ... }:
{
  home.packages = with pkgs; [
    keet # P2P Chat
    evince # GNOME's document viewer
    mission-center # Monitor your CPU, Memory, Disk, Network and GPU usage
    celluloid # Simple GTK frontend for the mpv video player
    mediawriter # Tool to write images files to portable media
  ];
}
