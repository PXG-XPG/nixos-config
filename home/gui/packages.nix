{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mission-center # Monitor your CPU, Memory, Disk, Network and GPU usage
    # mediawriter # Tool to write images files to portable media
    vscodium-fhs # Wrapped variant of vscodium which launches in a FHS compatible environment
    shotcut # Free, open source, cross-platform video editor
    haruna # Open source video player built with Qt/QML and libmpv
    moonlight-qt # Play your PC games on almost any device
    fceux # Nintendo Entertainment System (NES) Emulator
  ];
}
