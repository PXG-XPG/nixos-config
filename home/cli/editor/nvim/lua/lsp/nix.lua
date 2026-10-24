-- Nix: nixd (lspconfig name: nixd) — flake-aware
-- 依赖已装：nil / nixd / nixfmt（均在 extraPackages）。
--
-- 提供：
--   - nixpkgs 补全（import <nixpkgs> { }）
--   - NixOS 选项补全（nixosConfigurations.nixos.options）
--   - Home Manager 选项补全（homeConfigurations.<user>.options，见 /etc/nixos/flake.nix）
--   - nixfmt - 格式化（<leader>lf）
--
-- 备选：nil（更轻量，但无选项补全）；两者二选一，避免重复 attach。
-- 注意：home_manager 的 expr 依赖 flake 里存在 homeConfigurations 输出；
--       请先按 /etc/nixos/flake.nix 的修改 rebuild，否则该选项集求值会失败
--       （nixos 补全与格式化不受影响）。
vim.lsp.config("nixd", {
  settings = {
    nixd = {
      nixpkgs = {
        expr = "import <nixpkgs> { }",
      },
      formatting = {
        command = { "nixfmt", "-" },
      },
      options = {
        nixos = {
          expr = '(builtins.getFlake "/etc/nixos").nixosConfigurations.nixos.options',
        },
        home_manager = {
          expr = '(builtins.head (builtins.attrValues (builtins.getFlake "/etc/nixos").homeConfigurations)).options',
        },
      },
    },
  },
})

vim.lsp.enable({ "nixd" })
