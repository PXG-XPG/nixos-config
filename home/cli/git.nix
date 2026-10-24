{ config, ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = config.home.username;
        email = "rum66627@gmail.com";
      };
      init = {
        defaultBranch = "main";
      };
      safe = {
        directory = "/etc/nixos";
      };
    };
  };

  programs.gh = {
    enable = true;
  };

  programs.gh-dash = {
    enable = true;
  };

  programs.lazygit = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
  };
}
