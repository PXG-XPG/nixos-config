{ ... }:
{
  imports = [ 
      ./pc.nix

      # Include base configuration
      ./base

      # Include desktop configuration
      ./desktop

      # Include virtualisation configuration
      ./virtualisation
    ];
  
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
  };

  system.stateVersion = "26.05";
}
