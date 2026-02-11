{ ... }:

{
  programs.eza = {
    enable = true;
    colors = "auto";
    icons = "auto";
    git = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    extraOptions = [
      "--long" "--all" "--header" "--inode"
    ];
  };
}
