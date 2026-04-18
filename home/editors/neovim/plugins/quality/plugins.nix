{ pkgs, ... }:

{
  programs.nixvim.extraPlugins = with pkgs.vimPlugins; [
    nvim-treesitter
    indent-blankline-nvim
    gitsigns-nvim
    todo-comments-nvim
    persistence-nvim
    conform-nvim
    nvim-lint
  ];
}
