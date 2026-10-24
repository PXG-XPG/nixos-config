vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
})

require("render-markdown").setup({
  render_modes = { "n", "c", "t" },
  heading = { sign = false },
  bullet = {
    icons = { "●", "○", "◆", "◇" },
  },
})

vim.keymap.set("n", "<leader>mt", function()
  require("render-markdown").buf_toggle()
end, { desc = "Toggle markdown render" })
