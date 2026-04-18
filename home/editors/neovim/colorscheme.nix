{
  # Default theme: keep Everforest but with broader contrast comfort.
  programs.nixvim.colorschemes.everforest = {
    enable = true;
    settings = {
      background = "medium";
      better_performance = 1;
    };
  };

  programs.nixvim.extraConfigLua = ''
    local themes = {
      "everforest",
      "catppuccin",
      "tokyonight",
      "kanagawa",
      "gruvbox",
    }

    local function apply_random_theme()
      local seed = os.time() + vim.fn.localtime()
      math.randomseed(seed)
      local pick = themes[math.random(#themes)]
      local ok = pcall(vim.cmd.colorscheme, pick)
      if not ok then
        pcall(vim.cmd.colorscheme, "everforest")
      end
    end

    vim.api.nvim_create_autocmd("VimEnter", {
      group = vim.api.nvim_create_augroup("NixvimRandomTheme", { clear = true }),
      once = true,
      callback = apply_random_theme,
    })
  '';
}
