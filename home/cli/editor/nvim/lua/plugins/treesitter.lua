vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })

require("nvim-treesitter").setup({})

-- 安装 parser（异步；已安装则为 no-op）
require("nvim-treesitter").install({
  "lua",
  "c",
  "nix",
  "markdown",
  "markdown_inline",
  "query",
  "vim",
  "vimdoc",
  "bash",
  "json",
  "yaml",
  "toml",
})

-- 为已安装 parser 的语言启用 treesitter 特性：高亮、折叠、缩进
-- 注意：main 分支需手动开启，这里按语言能力（query 是否存在）决定是否开折叠/缩进
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match) or args.match
    if not vim.treesitter.language.add(lang) then
      return
    end

    -- 高亮
    vim.treesitter.start(args.buf)

    -- 折叠（仅当该语言提供 folds query）——foldexpr 是窗口选项
    if vim.treesitter.query.get(lang, "folds") then
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.wo.foldmethod = "expr"
    end

    -- 缩进（仅当该语言提供 indents query）——indentexpr 是缓冲区选项
    if vim.treesitter.query.get(lang, "indents") then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
