{ ... }:
{
  hardware.nvidia-container-toolkit.enable = true;
  imports = [
    ./libvirt.nix
    ./incus.nix
    ./podman.nix
  ];
}
