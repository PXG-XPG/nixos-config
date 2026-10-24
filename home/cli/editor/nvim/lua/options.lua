local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true

opt.scrolloff = 8
opt.splitright = true
opt.splitbelow = true

opt.ignorecase = true
opt.smartcase = true

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2

opt.undofile = true
opt.swapfile = false
opt.updatetime = 250

opt.timeoutlen = 300 -- 多键序列（含 <leader>）等待时间；越小 which-key 弹窗越快

opt.cmdheight = 0 -- ui2 实验性 cmdline：0 表示 cmdline 平时隐藏，按 : 时弹出浮动窗口

opt.clipboard = "unnamedplus" -- wl-clipboard 已由 neovim wrapper 注入 PATH

-- 折叠（foldmethod 由 treesitter 在支持的语言上设为 expr）
opt.foldlevel = 99 -- 启动时全部展开
opt.foldlevelstart = 99
opt.foldenable = true
opt.foldcolumn = "1"
