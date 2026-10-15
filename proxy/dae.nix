{ config, username, ... }:
{
  services.dae = {
    enable = true;
    openFirewall = {
      enable = true;
      port = 12345;
    };
    configFile = config.users.users.${username}.home + "/.config/dae/config.dae";
  };
}
