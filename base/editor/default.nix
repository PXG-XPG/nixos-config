{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.nano
    pkgs.helix
  ];

  environment.variables = {
    EDITOR = "hx -c /etc/nixos/base/editor/helix.toml";
  };
}
