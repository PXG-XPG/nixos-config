{
  config,
  pkgs,
  extraArgs,
  ...
}: 

{
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      lua-language-server
      gcc
      stylua
      ripgrep
      tree-sitter
    ];
  };

  home.file.".config/nvim" = {
    source = ./nvim;
    recursive = true;
  };
}
