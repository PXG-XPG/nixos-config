# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ 
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ 
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Include base configuration
      ./base

      # Include desktop configuration
      ./desktop

      # Include virtualisation configuration
      ./virtualisation
    ];

  # enalbe Flakes support
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
    ];
    shell = pkgs.bash;
    packages = with pkgs; [
    ];
  };

  environment.variables = {
    EDITOR = "nvim";
  };

  system.stateVersion = "26.05";
}
