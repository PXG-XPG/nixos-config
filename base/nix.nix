{ pkgs, ... }:
{
  nix = {
    package = pkgs.lix;
    settings = {
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
}
