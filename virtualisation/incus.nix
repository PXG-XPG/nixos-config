{ pkgs, ... }:
{
  networking.nftables.enable = true;
  networking.firewall.trustedInterfaces = [ "incusbr0" ]; 
  virtualisation.incus = {
    enable = true;
    preseed = {
      networks = [
        {
          name = "incusbr0";
          type = "bridge";
          config = {
            "ipv4.address" = "10.0.100.1/24";
            "ipv4.nat" = "true";
          };
        }
      ];
      profiles = [
        {
          name = "default";
          devices = {
            eth0 = { name = "eth0"; network = "incusbr0"; type = "nic"; };
            root = { path = "/"; pool = "default"; size = "50GiB"; type = "disk"; };
          };
        }
      ];
      storage_pools = [
        {
          name = "default";
          driver = "dir";
          config = { source = "/var/lib/incus/storage-pools/default"; };
        }
      ];
    };
  };
}
