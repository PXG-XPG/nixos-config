{ config, lib, pkgs, ... }:
{
  imports = [ 
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Include base configuration
      ./base

      # Include desktop configuration
      #./desktop

      # Include virtualisation configuration
      #./virtualisation
    ];
  
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rum= {
    isNormalUser = true;
    extraGroups = [ 
      "wheel"
      "networkmanager"
      "libvirt"
      "kvm"
      "docker"
      "podman"
      "gamemode"
      "incus-admin"
    ];
    shell = pkgs.bash;
  };

  security.sudo-rs.enable = true;

  system.stateVersion = "26.05";
}
