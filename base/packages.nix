{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # base tools
    git
    less
    wget
    curl
    gawk
    file
    exfatprogs
    tinyxxd
    # enhanced base tools
    lsd
    gping # ping, but with a graph(TUI)
    ncdu
    curlie # curl with httpie
    httpie
    bat
    # archives
    zip
    xz
    zstd
    unzipNLS
    p7zip
    # some utils
    pciutils # lspci
    usbutils # lsusb
    libva-utils
    lm_sensors # for `sensors` command
    # system monitors
    usbtop
    # useful tools
    fd
    ripgrep
    zoxide
    fzf
    jq
    # file manager
    yazi
    trash-cli
    hexyl
    ethtool
    mesa-demos
    vulkan-tools
    clinfo
    vdpauinfo
  ];
}
