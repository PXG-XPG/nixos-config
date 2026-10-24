-- Lua: lua-language-server (lspconfig name: lua_ls)
vim.lsp.config("lua_ls", {
  on_init = function(client)
    -- 若项目自带 .luarc.json(c)，尊重项目配置，不注入 Neovim 专用 runtime。
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath("config")
        and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = {
        version = "LuaJIT", -- Neovim 用 LuaJIT
        path = {
          "lua/?.lua",
          "lua/?/init.lua",
        },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME, -- 让 lua_ls 认识 vim.* 等全局
          vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
        },
      },
    })
  end,
  settings = {
    Lua = {
      -- vim 是 Neovim 注入的全局，lua_ls 默认不认识，声明为 read-only
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

vim.lsp.enable({ "lua_ls" })
