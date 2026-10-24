vim.pack.add({ "https://github.com/folke/tokyonight.nvim" })

require("tokyonight").setup({
  transparent = true,
})

vim.cmd.colorscheme("tokyonight")

-- Window separators (vertical splits + horizontal splits under 'laststatus=3')
-- default to a color almost identical to the background, so they disappear,
-- especially with transparent = true. Use tokyonight's comment color instead.
-- Swap for another palette color if you want it louder:
--   #414868 (subtle) / #565f89 / #737aa2 (strong) / #7aa2f7 (current, blue)
local separator_fg = "#7aa2f7"
local function set_separator_hl()
  vim.api.nvim_set_hl(0, "WinSeparator", { fg = separator_fg })
  vim.api.nvim_set_hl(0, "VertSplit", { fg = separator_fg })
end
set_separator_hl()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_separator_hl })
