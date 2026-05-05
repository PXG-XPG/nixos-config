{ pkgs, ... }:

{
  programs.nixvim.extraPlugins = with pkgs.vimPlugins; [
    opencode-nvim
  ];

  programs.nixvim.extraConfigLua = ''
    vim.o.autoread = true

    -- Configure opencode.nvim behavior; provider/model selection is handled by opencode.jsonc.
    vim.g.opencode_opts = vim.g.opencode_opts or {
      lsp = {
        enabled = false,
      },
    }
  '';
}
