vim.pack.add({ "https://github.com/folke/which-key.nvim" })

require("which-key").setup({
  preset = "helix",
  delay = 0, -- 立即弹出（多键序列等待由 timeoutlen=300 控制）
  icons = {
    mappings = false, -- 没有 Nerd Font 时设为 false，避免出现方块
  },
})

-- Human-readable group names for every <leader> prefix.
require("which-key").add({
  { "<leader>b", group = "Buffer" },
  { "<leader>c", group = "Code" },
  { "<leader>d", group = "Debug" },
  { "<leader>f", group = "Find" },
  { "<leader>h", group = "Hunk" },
  { "<leader>i", group = "Image" },
  { "<leader>l", group = "LSP" },
  { "<leader>m", group = "Markdown" },
  { "<leader>P", group = "Plugin" },
  { "<leader>q", desc = "Quit" },
  { "<leader>r", group = "Rename" },
  { "<leader>s", group = "Search" },
  { "<leader>t", group = "Toggle" },
  { "<leader>T", group = "Tab" },
  { "<leader>u", group = "Undo tree" },
  { "<leader>w", group = "Window" },
})
