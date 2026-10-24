vim.pack.add({ "https://github.com/stevearc/oil.nvim" })

require("oil").setup({
  view_options = { show_hidden = true },
  float = {
    padding = 2,
    max_width = 0.6,
    max_height = 0.6,
    border = "rounded",
  },
  -- 沿用 oil 默认的 buffer 内键位（<CR> 进入、- 上级、<C-s/h/t> 分屏等）
})

-- 全局入口键位
vim.keymap.set("n", "<leader>e", function()
  require("oil").open_float()
end, { desc = "Oil: toggle file manager (float)" })

vim.keymap.set("n", "<leader>E", function()
  require("oil").open(vim.fn.getcwd())
end, { desc = "Oil: open cwd" })
