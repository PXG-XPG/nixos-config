{ pkgs, ... }:
{
  virtualisation.containers.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  users.groups.podman.members = [ "rum" ];

  environment.systemPackages = with pkgs; [
    podman-tui
    podman-compose
  ];
}
