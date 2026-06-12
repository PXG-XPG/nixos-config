{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mission-center # Monitor your CPU, Memory, Disk, Network and GPU usage
    mediawriter # Tool to write images files to portable media
    btrfs-assistant # GUI management tool to make managing a Btrfs filesystem easier
  ];
}
