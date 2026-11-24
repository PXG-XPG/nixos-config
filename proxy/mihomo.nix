{ pkgs, config, ...}:
{
  services.mihomo = {
    enable = true;
    tunMode = true;
    configFile = config.users.users.rum.home + "/.config/mihomo/config.yaml";
  };
}
