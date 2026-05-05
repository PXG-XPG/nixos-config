{
  programs.nixvim.extraConfigLua = ''
    require("telescope").setup({})

    require("trouble").setup({})

    local ok_smart_splits, smart_splits = pcall(require, "smart-splits")
    if ok_smart_splits then
      smart_splits.setup({
        at_edge = "stop",
        move_cursor_same_row = false,
      })
    end

    require("neo-tree").setup({
      close_if_last_window = true,
      filesystem = {
        follow_current_file = { enabled = true },
      },
    })
  '';
}
