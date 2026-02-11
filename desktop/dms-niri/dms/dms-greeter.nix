{ pkgs, ... }:

{
  # Greeter
  services.displayManager.dms-greeter = {
    enable = true;
    # package = pkgs.dms-greeter;
    quickshell.package = pkgs.quickshell;
    logs = {
      save = true;
      path = "/tmp/dms-greeter.log";
    };
    compositor.name = "niri";

    configHome = "/home/rum";
    configFiles = [
      "/home/rum/.config/DankMaterialShell/settings.json"
      "/home/rum/.local/state/DankMaterialShell/session.json"
    ];
  };
}
