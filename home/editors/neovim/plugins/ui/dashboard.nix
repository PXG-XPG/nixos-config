{
  programs.nixvim.extraConfigLua = ''
    local ok_snacks, snacks = pcall(require, "snacks")
    if ok_snacks and snacks.dashboard then
      pcall(vim.api.nvim_del_user_command, "Dashboard")
      vim.api.nvim_create_user_command("Dashboard", function()
        snacks.dashboard.open()
      end, { desc = "Open Snacks Dashboard" })
    end
  '';
}
