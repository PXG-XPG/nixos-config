{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vscodium-fhs # Wrapped variant of vscodium which launches in a FHS compatible environment
    haruna # Open source video player built with Qt/QML and libmpv
    moonlight-qt # Play your PC games on almost any device
    fceux # Nintendo Entertainment System (NES) Emulator
  ];
}
