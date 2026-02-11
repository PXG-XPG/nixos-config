{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    shellWrapperName = "y";

    settings = {
      mgr = {
        show_hidden = true;
      };

      tasks = {
        image_alloc = 0;
      };

      preview = {
        max_width = 1000;
        max_height = 1000;
      };
    };

    plugins = {
      diff = pkgs.yaziPlugins.diff;
      chmod = pkgs.yaziPlugins.chmod;
      starship = pkgs.yaziPlugins.starship;
      full-border = pkgs.yaziPlugins.full-border;
      jump-to-char = pkgs.yaziPlugins.jump-to-char;
      lazygit = pkgs.yaziPlugins.lazygit;
    };

    initLua = ''
      require("starship"):setup()
      require("full-border"):setup()
    '';

    keymap = {
      mgr.append_keymap = [
        { on = [ "g" "w" ]; run = "cd ~/Workspace"; desc = "Go ~/Workspace"; }
        { on = [ "c" "m" ]; run = "plugin chmod"; desc = "Chmod on selected files"; }
        { on = [ "F" ]; run = "plugin jump-to-char"; desc = "Jump to char"; }
      ];
      mgr.prepend_keymap = [
        { on = [ "<C-d>" ]; run = "plugin diff"; desc = "Diff the selected with the hovered file"; }
        { on = [ "g" "i" ]; run = "plugin lazygit"; desc = "Run lazygit"; }
      ];
    };
  };
}
