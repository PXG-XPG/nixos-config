{ pkgs, ... }:
{
  # Define your hostname.
  networking.hostName = "nixos";

  # Enable NetworkManager for managing network connections.
  networking.networkmanager.enable = true;

  networking.firewall = {
    allowedTCPPorts = [ 53317 ]; # 53317 is for LocalSend
  };
}
