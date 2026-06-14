{ pkgs, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rum= {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "kvm"
      "greeter"
    ];
    shell = pkgs.bash;
  };
  security.sudo-rs.enable = true;
}
