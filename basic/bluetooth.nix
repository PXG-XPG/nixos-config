{ ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    hsphfpd.enable = true;
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
