{ pkgs, ... }:

{
  # Define your hostname.
  networking.hostName = "nixos";

  # Enable NetworkManager for managing network connections.
  networking.networkmanager.enable = true;
}
