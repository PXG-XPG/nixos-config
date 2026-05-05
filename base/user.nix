{ pkgs, ... }:
{
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
}
