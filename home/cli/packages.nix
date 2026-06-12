{ pkgs, ... }:
{
  home.packages = with pkgs; [
    android-tools # Android SDK platform tools
    nvitop # Interactive NVIDIA-GPU process viewer, the one-stop solution for GPU process management
  ];
}
