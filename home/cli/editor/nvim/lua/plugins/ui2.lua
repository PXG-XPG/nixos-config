-- ui2：Neovim 内置的实验性"消息 + 命令行 UI"重设计（:help ui2）。
--
-- 用浮动窗口 + 缓冲区替代传统 cmdline/message 网格：
--   - 不再出现 "Press ENTER" 中断
--   - 避免 W10 "Changing a readonly file" 等警告导致的延迟
--   - 输入命令时 cmdline 高亮
--   - pager 变成 buffer + window（任意时刻 g< 查看完整消息）
--   - 消息超出 cmdheight 时折叠，显示 [+x] spill 指示器
--   - cmdheight = 0 在 ui2 下效果更好
--
-- 模块路径带 _core 前缀 = 内部 API，版本间行为可能变化（master 上 cfg.pager_char /
-- cfg.msg.msg.timeout 已被 'messagesopt' 的 "pager"/"timeout" 项替代），升级后留意。
-- 若想停用，把本文件删掉（或把 enable 改成 disable：enable({ enable = false })）。

local ui2 = require("vim._core.ui2")

ui2.enable({
  enable = true,
  msg = {
    targets = "cmd",
    cmd = { height = 0.5 },
    dialog = { height = 0.5 },
    msg = { height = 0.5, timeout = 4000 },
    pager = { height = 1 },
  },
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("ui2_window_opts", { clear = true }),
  pattern = { "cmd", "msg", "pager", "dialog" },
  callback = function(ev)
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == ev.buf then
        local wo = vim.wo[win]
        wo.number = false
        wo.relativenumber = false
        wo.signcolumn = "no"
        wo.foldcolumn = "0"
        wo.wrap = true
        wo.linebreak = false
        wo.spell = false
      end
    end
  end,
})