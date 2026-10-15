{ pkgs, ... }:
{
  home.packages = with pkgs; [
    _7zz-rar # Support for RAR extraction
    glow # Render markdown on the CLI, with pizzazz
  ];
}
