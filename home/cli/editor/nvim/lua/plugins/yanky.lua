vim.pack.add({
  { src = "https://github.com/gbprod/yanky.nvim" },
})

require("yanky").setup({
  ring = {
    history_length = 100,
    storage = "shada",
    sync_with_numbered_registers = true,
    cancel_event = "update",
    ignore_registers = { "_" },
    update_register_on_cycle = false,
  },
  system_clipboard = {
    sync_with_ring = true,
  },
  highlight = {
    on_put = true,
    on_yank = true,
    timer = 500,
  },
  preserve_cursor_position = {
    enabled = true,
  },
})

vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)", { desc = "Yank text" })
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { desc = "Put after cursor" })
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", { desc = "Put before cursor" })
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", { desc = "Put after and stay" })
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", { desc = "Put before and stay" })

vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)", { desc = "Previous yank" })
vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)", { desc = "Next yank" })

vim.keymap.set("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)", { desc = "Put indented after" })
vim.keymap.set("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)", { desc = "Put indented before" })
vim.keymap.set("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)", { desc = "Put and indent right" })
vim.keymap.set("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", { desc = "Put and indent left" })
vim.keymap.set("n", "=p", "<Plug>(YankyPutAfterFilter)", { desc = "Put after filter" })

vim.keymap.set({ "n", "x" }, "<leader>p", "<cmd>YankyRingHistory<cr>", { desc = "Open yank history" })
