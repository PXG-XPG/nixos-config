{ pkgs, lib, config, ...}:
{
  services.mihomo = {
    enable = true;
    tunMode = true;
    webui = pkgs.zashboard;
    configFile = config.users.users.rum.home + "/.config/mihomo/config.yaml";
  };
}
