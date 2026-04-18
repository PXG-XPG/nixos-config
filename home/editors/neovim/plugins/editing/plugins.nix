{ pkgs, ... }:

{
  programs.nixvim.extraPlugins = with pkgs.vimPlugins; [
    nvim-autopairs
    comment-nvim
    nvim-surround
  ];
}
