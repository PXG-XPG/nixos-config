# Nixvim Troubleshooting

## 1. LSP did not attach

Symptoms:
- `gd` or `K` does nothing.
- `:checkhealth vim.lsp` shows server not enabled or no root.

Checks:
- Run `:checkhealth vim.lsp`.
- Verify filetype with `:set filetype?`.
- Verify root markers exist in project:
  - Haskell: `hie.yaml`, `cabal.project`, `stack.yaml`, `.git`
  - Verible: `verible.filelist`, `.git`
  - Metals: `build.sbt`, `build.sc`, `build.mill`, `.git`

Fixes:
- Ensure language server executable is installed in Home Manager packages.
- Open files inside a valid project root.
- Re-run `home-manager switch --no-write-lock-file --flake path:.#cake`.

## 2. Noice commandline popup does not appear

Symptoms:
- `:` still looks like vanilla commandline.

Checks:
- Run `:lua print(pcall(require, "noice"))`.
- Run `:Noice` and `:Noice history`.

Fixes:
- Ensure `noice-nvim`, `nui-nvim`, and `nvim-notify` are installed.
- Rebuild and restart Neovim fully.

## 3. CodeCompanion / OpenCode adapter not responding

Symptoms:
- `<leader>aa` / `<leader>ac` does nothing.
- `CCUseOpenCode` works but chat has no response.

Checks:
- Run `:checkhealth codecompanion`.
- Run `:checkhealth opencode`.
- Run `opencode --version` in terminal.
- Verify config exists at `~/.config/opencode/opencode.jsonc`.

Fixes:
- Ensure `codecompanion.nvim`, `copilot.lua`, and `opencode` are installed.
- Switch adapter with `:CCUseCopilot` or `:CCUseOpenCode` and retry.
- Confirm OpenCode provider config is valid in `~/.config/opencode/opencode.jsonc`.

## 4. Theme command fails

Symptoms:
- `:colorscheme catppuccin` (or others) returns not found.

Checks:
- `:colorscheme` to list loaded schemes.
- Confirm theme plugin exists in `plugins/ui/plugins.nix`.

Fixes:
- Rebuild with Home Manager and restart Neovim.
- Use one of the guaranteed configured themes:
  - `everforest`, `catppuccin`, `tokyonight`, `kanagawa`, `gruvbox`

## 5. Build succeeds but old behavior remains

Symptoms:
- Old mappings or UI behavior still active.

Checks:
- Ensure no local `~/.config/nvim` files override generated config.
- Verify `init.lua` points to Home Manager generated config.

Fixes:
- Run `home-manager switch --no-write-lock-file --flake path:.#cake`.
- Close all Neovim instances and relaunch.
- If needed, clear Neovim state cache:
  - `rm -rf ~/.local/state/nvim ~/.local/share/nvim`

## 6. Quick rollback

If a new module causes issues, comment it out in:
- `modules/vim/nixvim/plugins/default.nix`

Then run:
- `home-manager switch --no-write-lock-file --flake path:.#cake`
