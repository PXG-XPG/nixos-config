{ pkgs, config, ...}:
{
  services.mihomo = {
    enable = true;
    tunMode = true;
    configFile = config.users.users.rum.home + "/.config/mihomo/config.yaml";
  };

  # networking.firewall.trustedInterfaces = [ "Meta" ];
  networking.firewall.checkReversePath = false;
}
