vim.pack.add({
  {
    src = "https://github.com/ibhagwan/fzf-lua",
    version = "a306c293b37b",
  },
})

local fzf = require("fzf-lua")

fzf.setup({
  "default-title",
  files = {
    fd_opts = "--color=never --type f --hidden --follow --exclude .git",
  },
  grep = {
    rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -g '!*.min.*'",
  },
  keymap = {
    builtin = {
      -- [1] = true：保留 fzf-lua 的默认键位（bind 表是特例，不写这行会被整体替换）
      true,
      -- 把光标移进 preview 窗口：之后就能用普通 nvim 键翻页（ctrl-d/u/f/b）、
      -- 搜索（/ n）、跳转（gg G）等。
      -- 默认的 <S-down>/<M-S-down> 终端发不出来（终端不发送 Shift+方向键的转义序列）。
      ["<C-p>"] = "focus-preview",
    },
  },
})

-- 图片预览：用 image.nvim 在 fzf-lua 的 preview 浮窗（真实 nvim 窗口）里画图。
--
-- fzf-lua 的默认 previewer 是 "builtin"，它把内容渲染到一个真实的 nvim 浮窗里
-- （fzf 自己的 preview 区被隐藏、让 nvim 窗口透出来）。fzf-lua 在这里留了
-- attach_snacks_image_buf 这个钩子给 snacks.image 用；我们换成 image.nvim，
-- 因为 image.nvim 已经在 kitty / wezterm 里验证可用（markdown 图片弹窗）。
--
-- 注意：不要走 fzf 的 --preview + chafa/sixel 那条路 —— 那是"fzf 进程往终端
-- 输出图形转义序列"，fzf 对 kitty 图形协议的支持是 experimental，实测不可用。
local builtin = require("fzf-lua.previewer.builtin")

-- image.nvim 按字母序在本文件之后加载，必须惰性 require
local preview_image = nil -- 当前显示的图片实例

-- 清掉当前显示的图片。
-- 终端的图形层（kitty 协议）不会随文本重绘消失，所以从图片切到别的文件时
-- 必须显式清，否则图片会残留在 preview 窗口里、和文本叠在一起。
local function clear_preview_image()
  if not preview_image then
    return
  end
  local img = preview_image
  preview_image = nil
  pcall(function()
    img:clear()
  end)
end

-- 1) 每次切换预览项都先清掉上一张图。
--    populate_preview_buf 是渲染预览的入口，早于内部那些提前 return 的分支
--    （缓存命中、已加载的 buffer、location 等），所以清理放在这里最可靠。
local fzf_winid = nil -- fzf 的终端窗口（用于从 preview 窗口退回列表）
local last_topline = nil -- preview 窗口当前的首行（用于判断滚动条是否需要更新）

local orig_populate = builtin.buffer_or_file.populate_preview_buf
builtin.buffer_or_file.populate_preview_buf = function(self, entry_str, ...)
  clear_preview_image()
  if self.win then
    fzf_winid = self.win.fzf_winid
  end
  last_topline = nil -- 新内容渲染后强制更新一次滚动条
  return orig_populate(self, entry_str, ...)
end

-- focus-preview 把光标移进 preview 窗口后，需要一个方式退回 fzf 列表。
-- fzf-lua 没有内置的 focus-picker，这里在 preview 窗口里用 <Esc> 退回。
--
-- 另外，全局把 <C-h/j/k/l> 映射成了 <C-w>h/j/k/l（窗口跳转），但 preview 是浮窗，
-- <C-w>h 在浮窗上会跳到浮窗之外的普通窗口 → 光标跑出整个 fzf-lua。
-- 所以在 preview 窗口里把它们覆盖成滚动（只影响 preview 缓冲区，不动全局键位）。
local preview_scroll_maps = {
  ["<C-j>"] = "gj", -- 下一行
  ["<C-k>"] = "gk", -- 上一行
  ["<C-h>"] = "zh", -- 左滚（F3 关掉 wrap 后才有意义）
  ["<C-l>"] = "zl", -- 右滚
}

local function set_preview_keymaps()
  local win = vim.api.nvim_get_current_win()
  local ok, is_preview = pcall(vim.api.nvim_win_get_var, win, "fzf_lua_preview")
  if not (ok and is_preview) then
    return
  end
  local buf = vim.api.nvim_get_current_buf()
  vim.keymap.set("n", "<Esc>", function()
    local target = fzf_winid
    if not (target and vim.api.nvim_win_is_valid(target)) then
      local w = require("fzf-lua.win").__SELF()
      target = w and w.fzf_winid or nil
    end
    if target and vim.api.nvim_win_is_valid(target) then
      vim.api.nvim_set_current_win(target)
      -- 终端缓冲区里 insert 模式 == 终端模式；不进入的话方向键会被 nvim 自己吃掉
      -- （表现为光标能在 fzf 窗口里乱跑，得按 i 才恢复）。
      vim.cmd("startinsert")
    else
      -- 兜底：preview 是唯一出口被锁死之后，别让人真的困住。
      -- wincmd 是 Ex 命令，不受 <C-w> 的 <Nop> 映射影响。
      vim.cmd("wincmd p")
    end
  end, { buffer = buf, silent = true, nowait = true })
  for lhs, rhs in pairs(preview_scroll_maps) do
    vim.keymap.set("n", lhs, rhs, { buffer = buf, silent = true, nowait = true })
  end
  -- 锁死出口：preview 窗口只能用 <Esc> 退出。
  --  <C-w> 是所有窗口命令的前缀（<C-w>w/h/c/q ...），关掉可防止误触跳出，
  --        也避免 <C-w>c 直接把 preview 浮窗关掉、让 fzf-lua 的 preview_winid 失效。
  --  ":"    同理：:q / :close / :wincmd 都能离开或关掉窗口。
  --  注意这只是缓冲区局部映射，普通 buffer 里的 <C-w> 完全不受影响。
  vim.keymap.set("n", "<C-w>", "<Nop>", { buffer = buf, silent = true, nowait = true })
  vim.keymap.set("n", ":", "<Nop>", { buffer = buf, silent = true, nowait = true })
  -- 顺带关掉 q：否则 ":q" 被 <Nop> 吃掉 ":" 后，q 会开始录制宏（等寄存器），很迷惑。
  vim.keymap.set("n", "q", "<Nop>", { buffer = buf, silent = true, nowait = true })
end

-- WinEnter：切换窗口时；BufWinEnter：窗口内换 buffer 时（两种都要覆盖）
vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
  callback = set_preview_keymaps,
})

-- 用普通 nvim 键滚动 preview 时，fzf-lua 不知道滚动到哪了 → 滚动条不跟随。
-- 滚动条是 fzf-lua 用独立浮窗画的（win/scrollbar.lua），靠窗口的 topline 计算，
-- 所以这里监听滚动/光标移动，主动调 update_preview_scrollbar()。
local scrollbar_timer = nil

vim.api.nvim_create_autocmd({ "WinScrolled", "CursorMoved" }, {
  callback = function(args)
    local self_ = require("fzf-lua.win").__SELF()
    if not self_ or not self_.preview_winid or not vim.api.nvim_win_is_valid(self_.preview_winid) then
      return
    end
    -- WinScrolled 的 <amatch> 是窗口 id；CursorMoved 的是 <abuf>
    local is_preview = (args.match and tonumber(args.match) == self_.preview_winid)
      or args.buf == vim.api.nvim_win_get_buf(self_.preview_winid)
    if not is_preview then
      return
    end
    if scrollbar_timer then
      return
    end
    scrollbar_timer = vim.defer_fn(function()
      scrollbar_timer = nil
      local topline = vim.fn.line("w0", self_.preview_winid)
      if topline == last_topline then
        return
      end
      last_topline = topline
      pcall(function()
        self_:update_preview_scrollbar()
      end)
    end, 30)
  end,
})

-- 2) 关掉 picker 时清图，否则屏幕上会留一块残影
local orig_close = builtin.buffer_or_file.close
builtin.buffer_or_file.close = function(self, ...)
  clear_preview_image()
  return orig_close(self, ...)
end

-- 3) 图片本身：接管 fzf-lua 给 snacks.image 预留的钩子
builtin.buffer_or_file.attach_snacks_image_buf = function(self, buf, entry)
  local path = entry and entry.path
  if not path then
    return false
  end

  local ok_magic, magic = pcall(require, "image/utils/magic")
  if not ok_magic or not magic.is_image(path) then
    return false
  end

  local win = self.win and self.win.preview_winid
  if not win or not vim.api.nvim_win_is_valid(win) then
    return false
  end

  local ok, img = pcall(function()
    return require("image").from_file(path, {
      buffer = buf,
      window = win,
      x = 0,
      y = 0,
      -- 铺满 preview 窗口（全局配置里默认只占 50% 高）
      max_width_window_percentage = 100,
      max_height_window_percentage = 100,
    })
  end)
  if not ok or not img then
    return false
  end
  preview_image = img

  -- 与 fzf-lua 的 snacks 分支保持一致
  entry.do_not_cache = true
  entry.no_scrollbar = true
  self.clear_on_redraw = true
  self:set_preview_buf(buf, true)

  -- buffer 显示后再渲染，位置才正确
  vim.schedule(function()
    if preview_image == img and vim.api.nvim_win_is_valid(win) then
      pcall(function()
        img:render()
      end)
    end
  end)
  return true
end

vim.keymap.set("n", "<leader>ff", function()
  fzf.files()
end, { desc = "Find files" })

vim.keymap.set("n", "<leader>fg", function()
  fzf.live_grep()
end, { desc = "Live grep" })

vim.keymap.set("n", "<leader>fb", function()
  fzf.buffers()
end, { desc = "Find buffers" })

vim.keymap.set("n", "<leader>fr", function()
  fzf.oldfiles()
end, { desc = "Recent files" })

vim.keymap.set("n", "<leader>fh", function()
  fzf.help_tags()
end, { desc = "Help tags" })
