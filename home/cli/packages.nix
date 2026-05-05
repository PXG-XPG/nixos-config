{ pkgs, ... }:
{
  home.packages = with pkgs; [
    android-tools # Android SDK platform tools
  ];
}
