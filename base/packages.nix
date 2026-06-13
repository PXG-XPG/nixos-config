{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    exfatprogs
    e2fsprogs
    btrfs-progs
    p7zip
    pciutils # lspci
    usbutils # lsusb
    libva-utils
    lm_sensors # for `sensors` command
    usbtop
    fd
    ripgrep
    zoxide
    fzf
    jq
    yazi # File manager
    trash-cli
    ethtool
    mesa-demos
    vulkan-tools
    clinfo
    vdpauinfo
  ];
}
