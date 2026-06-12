{ ... }:
{
  imports = [ 
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Include base configuration
      ./base

      # Include desktop configuration
      ./desktop

      # Include virtualisation configuration
      ./virtual
    ];
  
  system.stateVersion = "26.05";
}
