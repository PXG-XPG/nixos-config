vim.pack.add({
  -- vim.pack 用 tag 名作为版本；锁定 v1 稳定版（v2 尚在开发中）
  { src = "https://github.com/saghen/blink.cmp", version = "v1.10.2" },
  { src = "https://github.com/rafamadriz/friendly-snippets", version = "main" },
})

require("blink.cmp").setup({
  -- 使用 Lua 版模糊匹配器：无需 cargo / 预编译二进制
  fuzzy = { implementation = "lua" },
  -- super-tab：Tab 接受/选择补全项（类似 VSCode）
  keymap = {
    preset = "super-tab",
    -- 只用 <Up>/<Down> 上下选择，取消内置的 <C-p>/<C-n>
    ["<C-p>"] = false,
    ["<C-n>"] = false,
  },
  appearance = {
    nerd_font_variant = "mono",
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  signature = { enabled = true },
  completion = {
    list = {
      -- super-tab 推荐：不预设选中项，避免在片段中误接受
      selection = {
        preselect = function(ctx)
          return not require("blink.cmp").snippet_active({ direction = 1 })
        end,
      },
    },
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
  },
})
