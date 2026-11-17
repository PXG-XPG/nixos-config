{ ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    hsphfpd.enable = false;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };
}
