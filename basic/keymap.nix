{ ... }:
{
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
            # Hold right Alt as a navigation layer
            rightalt = "layer(fn)";
	        };
	        otherlayer = {};
	        fn = {
	          h = "left";
	          j = "down";
	          k = "up";
	          l = "right";
	          a = "end";        # right Alt + a -> 行尾
	          i = "home";       # right Alt + i -> 行首
	          d = "delete";     # right Alt + d -> Delete
	          b = "backspace";  # right Alt + b -> Backspace
	        };
        };
      };
    };
  };
}
