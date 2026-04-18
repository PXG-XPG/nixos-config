{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.80;
        dynamic_title = true;
        option_as_alt = "Both"; # Option key acts as Alt on macOS
        decorations = "None"; # Show neither borders nor title bar
      };
      scrolling = {
        history = 10000;
      };
      font = {
        normal = {
          family = "ComicShannsMonoNerdFont";
        };
        size = 19;
      };
      terminal = {
        # Spawn a nushell in login mode via `bash`
        shell = {
          program = "${pkgs.bash}/bin/bash";
          args = [
            "--login"
            "-c"
            "su -"
          ];
        };
      };
      keyboard.bindings = [
        # Copy and paste
        { key = "Y"; mods = "Control"; action = "Paste"; }
        { key = "W"; mods = "Alt"; action = "Copy"; }
        # Scroll
        { key = "P"; mods = "Alt"; action = "ScrollLineUp"; }
        { key = "N"; mods = "Alt"; action = "ScrollLineDown"; }
        # Vi mode
        { key = "Space"; mods = "Control"; action = "ToggleViMode"; }
      ];
    };
  };
}
