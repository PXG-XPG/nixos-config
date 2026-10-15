{ pkgs, ... }:
{
  home.packages = with pkgs; [
    android-tools # Android SDK platform tools
    scrcpy # Display and control Android devices over USB or TCP/IP
    payload-dumper-go # Android OTA payload dumper written in Go
    nvtopPackages.nvidia # htop-like task monitor for AMD, Adreno, Intel and NVIDIA GPUs
  ];
}
