{ ... }:
{
  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        # Select all keyboards
        ids = [ "*" ];
        settings = {
          main = {
	    # Map capslock to leftcontrol
            capslock = "leftcontrol";

            # Map escape to capslock
	    esc = "capslock";

	    # Map leftcontrol to escape
	    leftcontrol = "esc";
	  };

	  otherlayer = {};
        };
      };
    };
  };
}
