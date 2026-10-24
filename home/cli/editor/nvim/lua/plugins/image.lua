vim.pack.add({
  { src = "https://github.com/3rd/image.nvim" },
})

local image = require("image")

image.setup({
  backend = "kitty",
  processor = "magick_cli",
  integrations = {
    markdown = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = true,
      only_render_image_at_cursor_mode = "popup",
      floating_windows = false,
      filetypes = { "markdown", "vimwiki" },
    },
  },
  max_height_window_percentage = 50,
  hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
})

local function close_image_popups()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "image_nvim_popup" and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end
end

local function toggle_images()
  if image.is_enabled() then
    image.disable()
    close_image_popups()
    vim.notify("image.nvim disabled", vim.log.levels.INFO)
  else
    image.enable()
    vim.notify("image.nvim enabled", vim.log.levels.INFO)
  end
end

vim.keymap.set("n", "<leader>ic", toggle_images, { desc = "Toggle image preview" })
