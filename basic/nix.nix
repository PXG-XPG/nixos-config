{ pkgs, username, ... }:
{
  nix = {
    settings = {
      trusted-users = [ username ];
      experimental-features = [
        "auto-allocate-uids"
        "nix-command"
        "cgroups"
        "flakes"
      ];
      use-cgroups = true;
      use-xdg-base-directories = true;
      auto-optimise-store = true;
      auto-allocate-uids = true;
    };
  };

  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
  };
}
