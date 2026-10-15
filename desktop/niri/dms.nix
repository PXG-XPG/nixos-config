{ config, pkgs, username, ... }:
{
  # Greeter（登录界面，服务 niri）
  services.displayManager.dms-greeter = {
    enable = true;
    quickshell.package = pkgs.quickshell;
    logs = {
      save = true;
      path = "/tmp/dms-greeter.log";
    };
    compositor.name = "niri";

    configHome = config.users.users.${username}.home;
    configFiles = [
      "${config.users.users.${username}.home}/.config/DankMaterialShell/settings.json"
      "${config.users.users.${username}.home}/.local/state/DankMaterialShell/session.json"
    ];
  };

  # Shell（顶栏/边栏等）
  programs.dms-shell = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
      restartIfChanged = true;
    };
    quickshell.package = pkgs.quickshell;
    enableVPN = true;
    enableDynamicTheming = true;
    enableCalendarEvents = true;
    enableAudioWavelength = true;
  };

  # dsearch（启动器）
  programs.dsearch = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
  };
}
