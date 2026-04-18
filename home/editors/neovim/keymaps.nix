{
  programs.nixvim.keymaps = [
    { mode = "n"; key = "<leader>e"; action = "<cmd>Neotree toggle<CR>"; options = { silent = true; desc = "Explorer"; }; }

    # Telescope
    { mode = "n"; key = "<leader>ff"; action = "<cmd>Telescope find_files<CR>"; options = { silent = true; desc = "Find Files"; }; }
    { mode = "n"; key = "<leader>fg"; action = "<cmd>Telescope live_grep<CR>"; options = { silent = true; desc = "Live Grep"; }; }
    { mode = "n"; key = "<leader>fb"; action = "<cmd>Telescope buffers<CR>"; options = { silent = true; desc = "Find Buffers"; }; }
    { mode = "n"; key = "<leader>fr"; action = "<cmd>Telescope oldfiles<CR>"; options = { silent = true; desc = "Recent Files"; }; }

    # Buffer 切换 (LazyVim/AstroNvim style)
    { mode = "n"; key = "<S-h>"; action = "<cmd>bprevious<CR>"; options = { silent = true; desc = "Prev Buffer"; }; }
    { mode = "n"; key = "<S-l>"; action = "<cmd>bnext<CR>"; options = { silent = true; desc = "Next Buffer"; }; }
    { mode = "n"; key = "<leader>bd"; action = "<cmd>bdelete<CR>"; options = { silent = true; desc = "Delete Buffer"; }; }

    # 原生 LSP
    { mode = "n"; key = "gd"; action = "<cmd>lua vim.lsp.buf.definition()<CR>"; options = { silent = true; desc = "LSP Definition"; }; }
    { mode = "n"; key = "gD"; action = "<cmd>lua vim.lsp.buf.declaration()<CR>"; options = { silent = true; desc = "LSP Declaration"; }; }
    { mode = "n"; key = "gi"; action = "<cmd>lua vim.lsp.buf.implementation()<CR>"; options = { silent = true; desc = "LSP Implementation"; }; }
    { mode = "n"; key = "gr"; action = "<cmd>Telescope lsp_references<CR>"; options = { silent = true; desc = "LSP References"; }; }
    { mode = "n"; key = "K"; action = "<cmd>lua vim.lsp.buf.hover()<CR>"; options = { silent = true; desc = "LSP Hover"; }; }
    { mode = "n"; key = "<leader>lr"; action = "<cmd>lua vim.lsp.buf.rename()<CR>"; options = { silent = true; desc = "LSP Rename"; }; }
    { mode = "n"; key = "<leader>la"; action = "<cmd>lua vim.lsp.buf.code_action()<CR>"; options = { silent = true; desc = "LSP Code Action"; }; }
    { mode = "n"; key = "<leader>ld"; action = "<cmd>Telescope diagnostics bufnr=0<CR>"; options = { silent = true; desc = "Buffer Diagnostics"; }; }

    # 诊断与问题列表
    { mode = "n"; key = "[d"; action = "<cmd>lua vim.diagnostic.goto_prev()<CR>"; options = { silent = true; desc = "Prev Diagnostic"; }; }
    { mode = "n"; key = "]d"; action = "<cmd>lua vim.diagnostic.goto_next()<CR>"; options = { silent = true; desc = "Next Diagnostic"; }; }
    { mode = "n"; key = "<leader>xx"; action = "<cmd>Trouble diagnostics toggle<CR>"; options = { silent = true; desc = "Toggle Trouble"; }; }

    # Noice / 消息历史
    { mode = "n"; key = "<leader>nn"; action = "<cmd>Noice history<CR>"; options = { silent = true; desc = "Noice History"; }; }
    { mode = "n"; key = "<leader>nl"; action = "<cmd>Noice last<CR>"; options = { silent = true; desc = "Noice Last"; }; }
    { mode = "n"; key = "<leader>nd"; action = "<cmd>Noice dismiss<CR>"; options = { silent = true; desc = "Noice Dismiss"; }; }

    # UI 快捷开关
    { mode = "n"; key = "<leader>ux"; action = "<cmd>Noice<CR>"; options = { silent = true; desc = "Open Noice"; }; }
    { mode = "n"; key = "<leader>us"; action = "<cmd>lua local ok,snacks = pcall(require, 'snacks'); if ok and snacks.picker then snacks.picker.files() end<CR>"; options = { silent = true; desc = "Snacks Files"; }; }
    { mode = "n"; key = "<leader>ud"; action = "<cmd>lua local ok,snacks = pcall(require, 'snacks'); if ok and snacks.dashboard then snacks.dashboard.open() end<CR>"; options = { silent = true; desc = "Open Dashboard"; }; }
    { mode = "n"; key = "<leader>ut"; action = "<cmd>ToggleTerm direction=float<CR>"; options = { silent = true; desc = "Terminal Float"; }; }
    { mode = "n"; key = "<leader>uh"; action = "<cmd>ToggleTerm size=14 direction=horizontal<CR>"; options = { silent = true; desc = "Terminal Horizontal"; }; }
    { mode = "n"; key = "<leader>uv"; action = "<cmd>ToggleTerm size=60 direction=vertical<CR>"; options = { silent = true; desc = "Terminal Vertical"; }; }
    { mode = "n"; key = "<leader>gg"; action = "<cmd>LazyGit<CR>"; options = { silent = true; desc = "LazyGit"; }; }

    # 窗口管理
    { mode = "n"; key = "<C-h>"; action = "<cmd>lua require('smart-splits').move_cursor_left()<CR>"; options = { silent = true; desc = "Window Left"; }; }
    { mode = "n"; key = "<C-j>"; action = "<cmd>lua require('smart-splits').move_cursor_down()<CR>"; options = { silent = true; desc = "Window Down"; }; }
    { mode = "n"; key = "<C-k>"; action = "<cmd>lua require('smart-splits').move_cursor_up()<CR>"; options = { silent = true; desc = "Window Up"; }; }
    { mode = "n"; key = "<C-l>"; action = "<cmd>lua require('smart-splits').move_cursor_right()<CR>"; options = { silent = true; desc = "Window Right"; }; }
    { mode = "n"; key = "<leader>wh"; action = "<C-w>h"; options = { silent = true; desc = "Window Left"; }; }
    { mode = "n"; key = "<leader>wj"; action = "<C-w>j"; options = { silent = true; desc = "Window Down"; }; }
    { mode = "n"; key = "<leader>wk"; action = "<C-w>k"; options = { silent = true; desc = "Window Up"; }; }
    { mode = "n"; key = "<leader>wl"; action = "<C-w>l"; options = { silent = true; desc = "Window Right"; }; }
    { mode = "n"; key = "<leader>wv"; action = "<cmd>vsplit<CR>"; options = { silent = true; desc = "Split Vertical"; }; }
    { mode = "n"; key = "<leader>ws"; action = "<cmd>split<CR>"; options = { silent = true; desc = "Split Horizontal"; }; }
    { mode = "n"; key = "<leader>wq"; action = "<cmd>close<CR>"; options = { silent = true; desc = "Close Window"; }; }
    { mode = "n"; key = "<leader>wo"; action = "<cmd>only<CR>"; options = { silent = true; desc = "Only Window"; }; }

    # Flash 快速跳转
    { mode = "n"; key = "s"; action = "<cmd>lua require('flash').jump()<CR>"; options = { silent = true; desc = "Flash Jump"; }; }
    { mode = "n"; key = "S"; action = "<cmd>lua require('flash').treesitter()<CR>"; options = { silent = true; desc = "Flash Treesitter"; }; }

    # 主题切换
    { mode = "n"; key = "<leader>tf"; action = "<cmd>colorscheme everforest<CR>"; options = { silent = true; desc = "Theme Everforest"; }; }
    { mode = "n"; key = "<leader>tc"; action = "<cmd>colorscheme catppuccin<CR>"; options = { silent = true; desc = "Theme Catppuccin"; }; }
    { mode = "n"; key = "<leader>tt"; action = "<cmd>colorscheme tokyonight<CR>"; options = { silent = true; desc = "Theme TokyoNight"; }; }
    { mode = "n"; key = "<leader>tk"; action = "<cmd>colorscheme kanagawa<CR>"; options = { silent = true; desc = "Theme Kanagawa"; }; }
    { mode = "n"; key = "<leader>tg"; action = "<cmd>colorscheme gruvbox<CR>"; options = { silent = true; desc = "Theme Gruvbox"; }; }

    # AI 快捷键
    { mode = "n"; key = "<leader>aa"; action = "<cmd>CodeCompanionActions<CR>"; options = { silent = true; desc = "CodeCompanion Actions"; }; }
    { mode = "n"; key = "<leader>ac"; action = "<cmd>CodeCompanionChat<CR>"; options = { silent = true; desc = "CodeCompanion Chat"; }; }
    { mode = "n"; key = "<leader>a1"; action = "<cmd>CCUseCopilot<CR>"; options = { silent = true; desc = "Use Copilot"; }; }
    { mode = "n"; key = "<leader>a2"; action = "<cmd>CCUseCodex<CR>"; options = { silent = true; desc = "Use Codex"; }; }
    { mode = "n"; key = "<leader>a4"; action = "<cmd>CCUseOpenCode<CR>"; options = { silent = true; desc = "Use OpenCode"; }; }
    { mode = "n"; key = "<leader>as"; action = "<cmd>CCShowAdapter<CR>"; options = { silent = true; desc = "Show Adapter"; }; }

    # Todo Comments
    { mode = "n"; key = "]t"; action = "<cmd>lua require('todo-comments').jump_next()<CR>"; options = { silent = true; desc = "Next Todo"; }; }
    { mode = "n"; key = "[t"; action = "<cmd>lua require('todo-comments').jump_prev()<CR>"; options = { silent = true; desc = "Prev Todo"; }; }
    { mode = "n"; key = "<leader>ft"; action = "<cmd>TodoTelescope<CR>"; options = { silent = true; desc = "Find Todos"; }; }

    # Session (persistence.nvim)
    { mode = "n"; key = "<leader>qs"; action = "<cmd>lua require('persistence').load()<CR>"; options = { silent = true; desc = "Restore Session"; }; }
    { mode = "n"; key = "<leader>ql"; action = "<cmd>lua require('persistence').load({ last = true })<CR>"; options = { silent = true; desc = "Restore Last Session"; }; }
    { mode = "n"; key = "<leader>qd"; action = "<cmd>lua require('persistence').stop()<CR>"; options = { silent = true; desc = "Stop Session Save"; }; }

    # 格式化
    { mode = "n"; key = "<leader>lf"; action = "<cmd>lua require('conform').format({ async = true, lsp_fallback = true })<CR>"; options = { silent = true; desc = "Format Buffer"; }; }
  ];
}
