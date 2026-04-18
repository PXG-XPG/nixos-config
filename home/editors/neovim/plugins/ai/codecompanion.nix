{ pkgs, ... }:

{
  programs.nixvim.extraPlugins = with pkgs.vimPlugins; [
    plenary-nvim
    copilot-lua
    codecompanion-nvim
  ];
}
