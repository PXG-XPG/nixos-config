# Nixvim Module Guide

## Overview

This directory contains a fully modular Nixvim setup split by capability.

- `default.nix`: top-level Nixvim entry and module imports.
- `opts.nix`, `globals.nix`, `colorscheme.nix`: baseline editor behavior and theme defaults.
- `keymaps.nix`: unified keybinding layer.
- `TROUBLESHOOTING.md`: common failure patterns and recovery steps.
- `plugins/`: feature modules.
  - `ai/`: codecompanion, opencode ACP adapter, render-markdown.
  - `lsp/`: native LSP (Neovim 0.11 API), split into `shared.nix` and `servers/`.
  - `completion/`: cmp + snippets.
  - `navigation/`: Telescope, Neo-tree, Trouble.
  - `editing/`: autopairs, comments, surround.
  - `quality/`: treesitter, formatting, lint, gitsigns.
  - `ui/`: Noice, Notify, Dressing, Flash, Snacks, extra themes.

## Feature Matrix

- LSP
  - Native `vim.lsp.config` + `vim.lsp.enable` pipeline.
  - Shared capabilities and per-server modular setup.
  - Servers configured: `clangd`, `rust_analyzer`, `hls`, `verible`, `metals`.
- Completion
  - `nvim-cmp` + `cmp-nvim-lsp` + `luasnip` + `friendly-snippets`.
- Navigation
  - Telescope find/grep/buffers/recent.
  - Neo-tree explorer.
  - Trouble diagnostics panel.
- UI
  - Noice commandline popup, markdown rendering override, and message routing.
  - Notify as the default notification backend.
  - Dressing for improved input/select prompts.
  - Flash for fast in-buffer jumps.
  - Snacks utility modules (input/notifier/picker/quickfile/statuscolumn/words).
- AI
  - CodeCompanion integration for actions/chat workflows.
  - OpenCode available as a CodeCompanion ACP adapter.
  - Render Markdown support for markdown buffers.

## Keymap Cheatsheet

Leader key is space.

- `a` AI
  - `<leader>aa`: CodeCompanion actions.
  - `<leader>ac`: CodeCompanion chat.
  - `<leader>a1`: use Copilot adapter.
  - `<leader>a2`: use Codex adapter.
  - `<leader>a4`: use OpenCode ACP adapter.
  - `<leader>as`: show current adapter.
- `e` Explorer
  - `<leader>e`: toggle Neo-tree.
- `f` Find
  - `<leader>ff`: files.
  - `<leader>fg`: live grep.
  - `<leader>fb`: buffers.
  - `<leader>fr`: recent files.
- `l` LSP
  - `gd`, `gD`, `gi`, `gr`, `K`: go-to and hover actions.
  - `<leader>lr`: rename.
  - `<leader>la`: code action.
  - `<leader>ld`: buffer diagnostics via Telescope.
  - `<leader>lf`: format with Conform.
- `n` Notify / Noice
  - `<leader>nn`: Noice history.
  - `<leader>nl`: Noice last message.
  - `<leader>nd`: Noice dismiss.
- `u` UI
  - `<leader>ux`: open Noice.
  - `<leader>us`: Snacks file picker.
  - `<leader>ud`: open Dashboard.
- `t` Theme
  - `<leader>tf`: everforest.
  - `<leader>tc`: catppuccin.
  - `<leader>tt`: tokyonight.
  - `<leader>tk`: kanagawa.
  - `<leader>tg`: gruvbox.
- `x` Problems
  - `<leader>xx`: Trouble diagnostics toggle.
- Motion
  - `s`: Flash jump.
  - `S`: Flash treesitter jump.

## Theme Switching

Startup theme is randomly selected from:

- `everforest`
- `catppuccin`
- `tokyonight`
- `kanagawa`
- `gruvbox`

If random selection fails for any reason, fallback is `everforest` (`background = "medium"`).

Switch at runtime:

- `:colorscheme everforest`
- `:colorscheme catppuccin`
- `:colorscheme tokyonight`
- `:colorscheme kanagawa`
- `:colorscheme gruvbox`

Fast switch keymaps:

- `<leader>tf`, `<leader>tc`, `<leader>tt`, `<leader>tk`, `<leader>tg`

## CodeCompanion + OpenCode

Neovim uses `codecompanion.nvim` as the AI plugin. OpenCode is available as an ACP adapter, and OpenCode CLI/provider defaults are configured in Home Manager via `modules/opencode.nix`.

Default backend:

- provider id: `wataruu`
- base URL: `https://api.wataruu.me/v1`
- default model: `wataruu/gpt-5.4`

Config path:

- `~/.config/opencode/opencode.jsonc`

Health check:

- Run `:checkhealth codecompanion` and `:checkhealth opencode` after switching configs.

## Dashboard

Dashboard is enabled with image preview using:

- plugin: `snacks.nvim` (`dashboard` module)
- renderer: terminal section command with `chafa`
- image: `~/.nixconfigs/assets/asuka.jpg`

Rendering strategy:

- Color mode uses Snacks dashboard `terminal` section with:
  - `chafa -f symbols --symbols vhalf --size 112x34 --colors full --color-space rgb`
- This provides higher visual resolution than the previous dashboard setup.
- Fallback mode keeps dashboard usable with a `ZHAO CAKE`-style textual header when image prerequisites are missing.

Fallback behavior:

- If rendering fails or prerequisites are missing, a chunky ASCII `ZHAO CAKE` banner is shown.
- Dashboard still loads normally with a fallback footer message.

Why some setups look different:

- Many showcased Neovim dashboards are `snacks.dashboard`, `alpha-nvim`, or setups with `image.nvim`.
- Different dashboard plugins use different rendering paths, so image quality and color behavior can vary.

Open dashboard:

- `:Dashboard`
- `<leader>ud`

Note:

- OpenCode provider/model selection is managed by OpenCode config and credentials.

Security recommendation:

- `WATARUU_API_KEY` is currently configured via Home Manager session variables.
- For safer secret handling, move it to a private secrets manager and inject through env at login.

## Next Plugins To Consider

- `mini.nvim`
  - High-quality modular UX toolkit (pairs, ai textobjects, files, statusline).
- `todo-comments.nvim`
  - Makes TODO/FIXME style comments first-class searchable diagnostics.
- `oil.nvim`
  - Buffer-native file management alternative to tree explorers.
- `lazygit.nvim`
  - Embedded Git TUI inside Neovim workflows.
- `persistence.nvim`
  - Session restore with minimal friction after restart.
- `fidget.nvim`
  - Lightweight LSP progress and task feedback.
- `twilight.nvim` + `zen-mode.nvim`
  - Focus mode for writing/review sessions.
- `inc-rename.nvim`
  - Better rename UX with preview-style commandline updates.
