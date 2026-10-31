{ pkgs, ... }:
{
  services.desktopManager.plasma6.enable = true;

  # Default display manager for Plasma
  services.displayManager.plasma-login-manager.enable = true;

  # 扁平化精简：剔除用不到的默认应用
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    kmag
    kmousetool
    kmouth
    kmahjongg
    kolourpaint
    kontrast
    kpat
    ksystemlog
    kiten
    oxygen
    plasma-browser-integration
    discover
  ];

  environment.systemPackages = with pkgs.kdePackages; [
    kiten
    kdenlive
    kcalc
    kdf
    filelight
    isoimagewriter
    krdc
  ];
}
