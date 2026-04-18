{ pkgs, ... }:

{
  programs.distrobox = {
    enable = true;
    settings = {
      container_manager = "podman";
      skip_workdir = "0";
    };
  };
}
