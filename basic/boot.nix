{ pkgs, lib, ... }:
{
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = lib.mkDefault "keep";
        editor = false;
      };
      efi.canTouchEfiVariables = true;
      timeout = lib.mkDefault 8;
    };
    blacklistedKernelModules = [ "iTCO_wdt" ];
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;

    # 措施2：禁用 NVMe APST，避免空闲时电源状态切换导致掉盘（影响仅限该 NVMe）
    # 措施3：关闭 PCIe ASPM（影响全平台功耗，确认措施2无效后再取消下面注释）
    kernelParams = [
      "nvme_core.default_ps_max_latency_us=0"
      # "pcie_aspm.policy=performance"
    ];

    kernel.sysctl = {
      "kernel.sysrq" = 1;
      "kernel.hardlockup_all_cpu_backtrace" = 1;
      "kernel.softlockup_all_cpu_backtrace" = 1;
      "kernel.hardlockup_panic" = 1;    # 硬锁死直接 panic，配合下面 30s 自动重启
      "kernel.panic" = 30;
    };
  };
}
