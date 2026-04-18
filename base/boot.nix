{ pkgs, lib, ... }:
{
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = lib.mkDefault "max";
      };
      efi.canTouchEfiVariables = true;
      timeout = lib.mkDefault 8;
    };
    kernelParams = [ "nowatchdog" ];
    blacklistedKernelModules = [ "iTCO_wdt" ];
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
  };
}
