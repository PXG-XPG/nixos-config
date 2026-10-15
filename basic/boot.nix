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
    blacklistedKernelModules = [ "iTCO_wdt" ];
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
    kernel.sysctl = {
      "kernel.sysrq" = 1;
      "kernel.hardlockup_all_cpu_backtrace" = 1;
      "kernel.softlockup_all_cpu_backtrace" = 1;
      "kernel.hardlockup_panic" = 1;    # 硬锁死直接 panic，配合下面 30s 自动重启
      "kernel.panic" = 30;
    };
  };
}
