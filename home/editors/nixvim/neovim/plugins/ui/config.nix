{
  programs.nixvim.extraConfigLua = ''
    local ok_notify, notify = pcall(require, "notify")
    if ok_notify then
      vim.notify = notify
      notify.setup({
        background_colour = "#1f2329",
        timeout = 2500,
        render = "wrapped-compact",
        stages = "fade_in_slide_out",
        top_down = false,
        fps = 60,
      })
    end

    local ok_noice, noice = pcall(require, "noice")
    if ok_noice then
      noice.setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
          },
          progress = { enabled = true },
          signature = { enabled = true },
          hover = { enabled = true },
        },
        messages = {
          enabled = true,
          view = "notify",
          view_warn = "notify",
          view_error = "notify",
        },
        cmdline = {
          enabled = true,
          view = "cmdline_popup",
          format = {
            cmdline = { icon = "" },
            search_down = { icon = " " },
            search_up = { icon = " " },
            filter = { icon = "$" },
            lua = { icon = "" },
            help = { icon = "" },
          },
        },
        popupmenu = {
          enabled = true,
          backend = "nui",
        },
        routes = {
          {
            filter = {
              event = "msg_show",
              find = "written",
            },
            opts = { skip = true },
          },
        },
        presets = {
          command_palette = true,
          bottom_search = false,
          long_message_to_split = true,
          lsp_doc_border = true,
        },
      })
    end

    local ok_dressing, dressing = pcall(require, "dressing")
    if ok_dressing then
      dressing.setup({
        input = { enabled = true },
        select = { enabled = true },
      })
    end

    local ok_flash, flash = pcall(require, "flash")
    if ok_flash then
      flash.setup({})
    end

    local ok_toggleterm, toggleterm = pcall(require, "toggleterm")
    if ok_toggleterm then
      toggleterm.setup({
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        persist_mode = true,
        direction = "float",
        shade_terminals = true,
        float_opts = {
          border = "curved",
        },
      })
    end

    -- lazygit.nvim primarily exposes :LazyGit command; no setup() is required.

    vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { silent = true, desc = "Terminal Normal Mode" })
    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { silent = true, desc = "Window Left" })
    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { silent = true, desc = "Window Down" })
    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { silent = true, desc = "Window Up" })
    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { silent = true, desc = "Window Right" })

    local ok_snacks, snacks = pcall(require, "snacks")
    if ok_snacks then
      local image_path = vim.fn.expand("~/.nixconfigs/assets/asuka.jpg")
      local can_render_image = vim.fn.executable("chafa") == 1 and vim.fn.filereadable(image_path) == 1
      local dashboard_sections

      -- Keep the image inside the left pane by scaling to current editor size.
      local total_cols = vim.o.columns
      local total_lines = vim.o.lines
      local image_width = math.max(44, math.floor(total_cols * 0.42) - 2)
      local image_height = math.max(22, math.floor(total_lines * 0.64) - 2)
      local image_cmd = string.format(
        "chafa -f symbols --symbols block --size %dx%d --colors full --color-space rgb --dither ordered %s",
        image_width,
        image_height,
        vim.fn.shellescape(image_path)
      )

      if can_render_image then
        dashboard_sections = {
          {
            pane = 1,
            section = "terminal",
            cmd = image_cmd,
            height = image_height,
            padding = { 3, 0 },
          },
          { pane = 2, section = "header", padding = 0 },
          { pane = 2, icon = " ", title = "Keymaps", section = "keys", gap = 1, indent = 2, padding = { 1, 0 } },
          { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", limit = 7, indent = 2, padding = { 1, 0 } },
          { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = { 1, 0 } },
          { pane = 2, text = "Nixvim dashboard ready.", align = "center", padding = 0 },
        }
      else
        dashboard_sections = {
          { section = "header", padding = 0 },
          { icon = " ", title = "Keymaps", section = "keys", gap = 1, indent = 2, padding = { 1, 0 } },
          { icon = " ", title = "Recent Files", section = "recent_files", limit = 7, indent = 2, padding = { 1, 0 } },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = { 1, 0 } },
          { text = "Nixvim dashboard ready.", align = "center", padding = 0 },
        }
      end

      snacks.setup({
        input = { enabled = true },
        notifier = { enabled = true },
        picker = { enabled = true },
        quickfile = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
        dashboard = {
          enabled = true,
          sections = dashboard_sections,
          preset = {
            header = [[
 ██████╗  █████╗ ██╗  ██╗███████╗
██╔════╝ ██╔══██╗██║ ██╔╝██╔════╝
██║      ███████║█████╔╝ █████╗  
██║      ██╔══██║██╔═██╗ ██╔══╝  
╚██████╗ ██║  ██║██║  ██╗███████╗
 ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝
]],
            keys = {
              { icon = " ", key = "f", desc = "Find File", action = ":Telescope find_files" },
              { icon = "󰱼 ", key = "g", desc = "Live Grep", action = ":Telescope live_grep" },
              { icon = "󰈙 ", key = "r", desc = "Recent Files", action = ":Telescope oldfiles" },
              { icon = " ", key = "c", desc = "CodeCompanion Chat", action = ":CodeCompanionChat" },
              { icon = " ", key = "q", desc = "Quit", action = ":qa" },
            },
          },
        },
      })
    end
  '';
}
