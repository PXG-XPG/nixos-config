vim.pack.add({
  { src = "https://github.com/MagicDuck/grug-far.nvim", version = "1.6.79" },
})

require("grug-far").setup({})

-- 打开 grug-far（整个项目）
vim.keymap.set({ "n", "x" }, "<leader>sr", function()
  require("grug-far").open()
end, { desc = "Search & replace (project)" })

-- 用光标下的词预填搜索
vim.keymap.set("n", "<leader>sw", function()
  require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
end, { desc = "Search & replace word under cursor" })

-- 只在当前文件内替换
vim.keymap.set("n", "<leader>sf", function()
  require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
end, { desc = "Search & replace in current file" })

-- 可视选区：预填搜索并限定路径为当前文件
vim.keymap.set("x", "<leader>sF", function()
  require("grug-far").with_visual_selection({ prefills = { paths = vim.fn.expand("%") } })
end, { desc = "Search & replace selection in current file" })
