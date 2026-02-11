{ pkgs, ... }:

{
  services.flameshot = {
    enable = true;
    settings = {
      General = {
	    contrastOpacity = 188;
        disabledGrimWarning = true;
        useGrimAdapter = true;
      };
    };
  };
}
