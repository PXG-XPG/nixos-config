-- LSP 入口：安装 nvim-lspconfig、加载各语言配置、注册统一键位。
-- 各语言配置放在本目录下，每个文件一个语言，用 vim.lsp.config() 配置后
-- 由本文件统一 vim.lsp.enable()（或文件内自行 enable）。

vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })

-- 自动发现同目录下的语言配置文件（排除 init.lua），字母序加载
local dir = vim.fn.stdpath("config") .. "/lua/lsp"
local names = {}
for name in vim.fs.dir(dir) do
  if name:sub(-4) == ".lua" and name ~= "init.lua" then
    names[#names + 1] = (name:gsub("%.lua$", ""))
  end
end
table.sort(names)

for _, name in ipairs(names) do
  require("lsp." .. name)
end

-- 统一的 LSP 附加键位（所有语言服务器生效）
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local buf = args.buf
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
    end

    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
    map("n", "gr", vim.lsp.buf.references, "Go to references")
    map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
    map("n", "K", vim.lsp.buf.hover, "Hover documentation")
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>lf", function()
      vim.lsp.buf.format({ async = true })
    end, "Format buffer")

    -- clangd 专用：源文件/头文件切换（命令由 clangd 的 on_attach 注册）
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "clangd" then
      map("n", "<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", "Switch source/header")
    end
  end,
})
