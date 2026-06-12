{ ... }:
{
  imports = [
    ./cursorTheme.nix
    ./iconTheme.nix
  ];

  home.file.".config/niri" = {
    source = ./niri;
    recursive = true;
  };

  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };
}
