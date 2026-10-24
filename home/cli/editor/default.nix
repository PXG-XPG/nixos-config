{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    sideloadInitLua = false;

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

      bash-language-server   # 提供 bashls
      shellcheck             # bashls 用它做 lint/诊断
      shfmt                  # 可选：格式化（<leader>lf）

      basedpyright   # 提供 basedpyright-langserver
      ruff           # lint + format
      python3        # basedpyright 解析 import / 类型推断用
    ];
  };

  home.file.".config/nvim" = {
    source = ./nvim;
    recursive = true;
  };
}
