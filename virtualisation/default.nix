{ ... }:

{
  hardware.nvidia-container-toolkit.enable = true;

  imports = [
    # ./qemu-kvm.nix
    ./incus.nix
    #./docker.nix
    #./podman.nix
  ];
}
