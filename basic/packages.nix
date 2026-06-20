{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    exfatprogs
    e2fsprogs
    btrfs-progs
    pciutils # lspci
    usbutils # lsusb
    libva-utils
    git
    lm_sensors # for `sensors` command
    just
    usbtop
    helix
    trash-cli
    ethtool
    mesa-demos
    vulkan-tools
    clinfo
    vdpauinfo
  ];
}
