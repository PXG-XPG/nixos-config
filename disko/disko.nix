{ ... }:
{
  imports = [ ./disko-config.nix ];
  _module.args.disks = [ "/dev/nvme1n1" ];
}
