{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    sideloadInitLua = true;

    extraPackages = with pkgs; [
      tree-sitter
      gcc

      # LSP servers
      nil   # Nix language server (oxalica/nil)
      nixd  # Nix language server (nix-community)
      lua-language-server
      clang-tools     # 提供 clangd

      # DAP adapter (提供 lldb-dap)
      lldb

      # 搜索/替换 (grug-far 依赖)
      ripgrep

      # formatter
      nixfmt

      # 文件搜索 (fzf-lua 依赖)
      fzf
      fd

      # 图片预览
      imagemagick
      chafa      # fzf-lua 图片预览（kitty 图形协议）
    ];
  };
}
