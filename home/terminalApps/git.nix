{ ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = "rum";
        email = "rum66627@gmail.com";
      };
      init = {
        defaultBranch = "main";
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
