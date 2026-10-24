-- Python: basedpyright (类型检查/补全) + ruff (lint/format)
-- 依赖（NixOS）：在 /etc/nixos/home/cli/editor/default.nix 的 extraPackages 加：
--   basedpyright   # LSP 本体（node 包，含 basedpyright-langserver）
--   ruff           # lint + format（Rust 二进制，无 python 依赖）
--   python3        # basedpyright 解析 import / 类型推断用（可选但推荐）
-- 安装后 sudo nixos-rebuild switch，重启 nvim。
--
-- 两者分工：basedpyright 负责类型检查/补全/hover/rename，
-- ruff 负责 lint 诊断与 <leader>lf 格式化；互不冲突。
-- basedpyright 默认 settings 来自 lspconfig（autoSearchPaths、diagnosticMode=openFilesOnly）。
vim.lsp.config("basedpyright", {})

-- ruff LSP：diagnostics + code actions + formatting
vim.lsp.config("ruff", {})

vim.lsp.enable({ "basedpyright", "ruff" })
