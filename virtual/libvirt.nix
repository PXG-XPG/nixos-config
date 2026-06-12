{ pkgs, ... }:
{
  boot.kernelModules = [
    "kvm-intel"
    "vfio-pci"
  ];

  networking.firewall.trustedInterfaces = [ "virbr0" ];
  users.groups.libvirtd.members = [ "rum" ];

  programs.virt-manager.enable = true;
  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true; # 启用软件 TPM 支持
        runAsRoot = true; # 允许 QEMU 以 root 身份运行，以便访问某些硬件功能
      };
      onBoot = "ignore"; # 启动时不自动启动虚拟机,设置成"start"则自动启动
    };
  };

  systemd.services.libvirt-default-network = {
    description = "Start libvirt default network";
    after = ["libvirtd.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.libvirt}/bin/virsh net-start default";
      ExecStop = "${pkgs.libvirt}/bin/virsh net-destroy default";
      User = "root";
    };
  };

  environment.systemPackages = with pkgs; [
    qemu # QEMU 虚拟化工具
    qemu_kvm # KVM 支持的 QEMU 版本
    OVMF # UEFI 固件支持
    dnsmasq # 用于默认网络的 DHCP 服务
  ];
}
