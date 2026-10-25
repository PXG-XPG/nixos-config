{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    exfatprogs
    e2fsprogs
    pciutils # lspci
    usbutils # lsusb
    alsa-utils
    lm_sensors # for `sensors` command
    file
    just
    usbtop
    trash-cli
    ethtool
    mesa-demos
    vulkan-tools
    clinfo
    vdpauinfo
  ];
}
