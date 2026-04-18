{ pkgs, ... }:

{
  programs.nixvim.extraPlugins = with pkgs.vimPlugins; [
    render-markdown-nvim
  ];

  programs.nixvim.extraConfigLua = ''
    local ok_render_markdown, render_markdown = pcall(require, "render-markdown")
    if ok_render_markdown then
      render_markdown.setup({
        file_types = { "markdown", "codecompanion" },
      })
    end
  '';
}
