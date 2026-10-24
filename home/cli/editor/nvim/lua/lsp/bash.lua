-- Bash: bash-language-server (lspconfig name: bashls)
-- 依赖（NixOS）：在 /etc/nixos/home/cli/editor/default.nix 的 extraPackages 加：
--   bash-language-server   # LSP 本体
--   shellcheck             # 诊断/lint（bashls 依赖它做检查）
--   shfmt                  # 可选：格式化（<leader>lf）
-- 安装后 sudo nixos-rebuild switch，重启 nvim。
-- 无 compile_commands.json 等价物；单文件也能提供补全与诊断。
vim.lsp.config("bashls", {})

vim.lsp.enable({ "bashls" })
