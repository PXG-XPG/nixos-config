vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 屏蔽内置 netrw（文件浏览交给 oil.nvim）
-- 必须在插件加载前设置，否则 netrw 会先加载
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("options")
require("keymaps")
require("plugins")
require("packmgr")
