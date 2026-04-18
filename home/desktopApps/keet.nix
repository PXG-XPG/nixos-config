{ pkgs, ... }:
{
  home.packages = with pkgs; [
    keet
  ];
}
