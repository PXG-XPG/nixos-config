-- C/C++: clangd (provided by clang-tools)
-- 无 compile_commands.json 时 clangd 仍能对单文件做基础补全与诊断。
-- 覆盖 cmd 为更实用的分析选项；on_attach 注册的
-- :LspClangdSwitchSourceHeader / :LspClangdShowSymbolInfo 沿用 lspconfig 默认。
vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
  },
})

vim.lsp.enable({ "clangd" })
