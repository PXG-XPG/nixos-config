{
  programs.nixvim.extraConfigLua = ''
    vim.g.codecompanion_chat_adapter = vim.g.codecompanion_chat_adapter or "copilot"
    vim.g.codecompanion_copilot_model = vim.g.codecompanion_copilot_model or "gpt-5.3-codex"
    vim.g.codecompanion_codex_model = vim.g.codecompanion_codex_model or "gpt-5.3-codex"
    vim.g.codecompanion_chat_width_cols = vim.g.codecompanion_chat_width_cols or 58
    vim.g.codecompanion_chat_width_ratio = vim.g.codecompanion_chat_width_ratio or 0.38

    require("copilot").setup({
      panel = { enabled = false },
      suggestion = { enabled = false },
    })

    local function setup_codecompanion(adapter_name)
      local function get_chat_width()
        local cols = tonumber(vim.g.codecompanion_chat_width_cols)
        if cols ~= nil and cols > 0 then
          return cols
        end

        local ratio = tonumber(vim.g.codecompanion_chat_width_ratio) or 0.38
        return math.max(40, math.floor(vim.o.columns * ratio))
      end

      local chat_adapter
      if adapter_name == "copilot" then
        chat_adapter = { name = "copilot", model = vim.g.codecompanion_copilot_model }
      elseif adapter_name == "codex" then
        chat_adapter = { name = "codex", model = vim.g.codecompanion_codex_model }
      else
        chat_adapter = adapter_name
      end

      require("codecompanion").setup({
        adapters = {
          acp = {
            codex = function()
              return require("codecompanion.adapters").extend("codex", {
                defaults = {
                  auth_method = (vim.env.OPENAI_API_KEY ~= nil and vim.env.OPENAI_API_KEY ~= "") and "openai-api-key" or "chatgpt",
                },
              })
            end,
            opencode = function()
              return require("codecompanion.adapters").extend("opencode", {
                defaults = {
                  timeout = 30000,
                },
              })
            end,
          },
        },
        interactions = {
          chat = {
            adapter = chat_adapter,
          },
          inline = {
            adapter = "copilot",
          },
          cmd = {
            adapter = "copilot",
          },
        },
        display = {
          chat = {
            window = {
              layout = "vertical",
              full_height = true,
              position = "right",
              width = get_chat_width(),
              border = "single",
              opts = {
                breakindent = true,
                linebreak = true,
                wrap = true,
              },
            },
          },
        },
      })
    end

    setup_codecompanion(vim.g.codecompanion_chat_adapter)

    vim.api.nvim_create_user_command("CCUseCopilot", function()
      vim.g.codecompanion_chat_adapter = "copilot"
      setup_codecompanion("copilot")
      vim.notify("CodeCompanion chat adapter: copilot")
    end, {})

    vim.api.nvim_create_user_command("CCUseCodex", function()
      vim.g.codecompanion_chat_adapter = "codex"
      setup_codecompanion("codex")
      vim.notify("CodeCompanion chat adapter: codex")
    end, {})

    vim.api.nvim_create_user_command("CCUseOpenCode", function()
      vim.g.codecompanion_chat_adapter = "opencode"
      setup_codecompanion("opencode")
      vim.notify("CodeCompanion chat adapter: opencode")
    end, {})

    vim.api.nvim_create_user_command("CCShowAdapter", function()
      local model = ""
      if vim.g.codecompanion_chat_adapter == "copilot" then
        model = vim.g.codecompanion_copilot_model
      elseif vim.g.codecompanion_chat_adapter == "codex" then
        model = vim.g.codecompanion_codex_model
      end
      vim.notify("Current CodeCompanion chat adapter: " .. tostring(vim.g.codecompanion_chat_adapter) .. " (model: " .. tostring(model) .. ")")
    end, {})
  '';
}
