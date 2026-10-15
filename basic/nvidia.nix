{ config, lib, ... }:
{
  boot.kernelParams = [
    "acpi_backlight=native"
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    nvidiaSettings = true;
    powerManagement.enable = true;
    gsp.enable = true;
    dynamicBoost.enable = lib.mkForce true;
    modesetting.enable = true;
    videoAcceleration = true;
    nvidiaPersistenced = true;
  };

  environment.sessionVariables = {
     LIBVA_DRIVER_NAME = "nvidia";
     GBM_BACKEND = "nvidia-drm";
     "NVD_BACKEND" = "direct";
     __GLX_VENDOR_LIBRARY_NAME = "nvidia";
     MOZ_DISABLE_RDD_SANDBOX = "1";   # 新增:放行 RDD 解码进程
  };
}
