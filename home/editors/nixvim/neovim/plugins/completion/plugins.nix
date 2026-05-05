{ pkgs, ... }:

{
  programs.nixvim.extraPlugins = with pkgs.vimPlugins; [
    nvim-cmp
    cmp-nvim-lsp
    cmp-buffer
    cmp-path
    luasnip
    cmp_luasnip
    friendly-snippets
  ];
}
