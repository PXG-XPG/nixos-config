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
    # enhanced base tools
    lsd
    gping # ping, but with a graph(TUI)
    ncdu
    curlie # curl with httpie
    httpie
    bat
    # editor
    neovim
    helix
    emacs
    # shell
    zsh
    fish
    nushell
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
    nvtopPackages.nvidia
    btop-cuda
    usbtop
    # useful tools
    fastfetch
    fd
    tree
    ripgrep
    zoxide
    fzf
    jq
    # file manager
    yazi
    aria2
    trash-cli
    hexyl
    direnv
    ethtool
    mesa-demos
    vulkan-tools
    clinfo
    vdpauinfo
  ];
}
