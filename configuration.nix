{ ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Include base configuration
    ./basic

    # Include desktop configuration
    ./desktop

    # Include virtualisation configuration
    ./virtual

    # Include proxy configuration (dae)
    ./proxy
  ];

  system.stateVersion = "26.05";
}
