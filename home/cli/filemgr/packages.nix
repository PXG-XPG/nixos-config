{ pkgs, ... }:
{
  home.packages = with pkgs; [
    _7zz-rar # Support for RAR extraction
  ];
}
