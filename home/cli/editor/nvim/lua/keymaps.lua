local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map({ "n", "i", "v", "x" }, "<C-s>", function()
  if vim.bo.modifiable and vim.bo.buftype == "" then
    vim.cmd("silent! write")
  end
end, { desc = "Save" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa<CR>", { desc = "Quit all" })

map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

map("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostic" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end)
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end)

-- 折叠（foldmethod=expr，由 treesitter 提供）
local fold = function(lhs, rhs, desc)
  map("n", lhs, rhs, { desc = desc })
end

fold("za", "za", "Toggle fold")
fold("zo", "zo", "Open fold")
fold("zc", "zc", "Close fold")
fold("zR", "zR", "Open all folds")
fold("zM", "zM", "Close all folds")
fold("zr", "zr", "Open folds one level")
fold("zm", "zm", "Close folds one level")
fold("zj", "zj", "Next fold")
fold("zk", "zk", "Prev fold")
map("n", "<leader>z", "za", { desc = "Toggle fold" })

-- Wrap visual selection with a bracket/quote pair
local wrap_pairs = {
  ["("] = { "(", ")" },
  [")"] = { "(", ")" },
  ["["] = { "[", "]" },
  ["]"] = { "[", "]" },
  ["{"] = { "{", "}" },
  ["}"] = { "{", "}" },
  ["<"] = { "<", ">" },
  [">"] = { "<", ">" },
  ['"'] = { '"', '"' },
  ["'"] = { "'", "'" },
  ["`"] = { "`", "`" },
}

-- Range of the active visual selection, using the anchor ("v") and cursor (".").
local function visual_range()
  local a = vim.fn.getpos("v")
  local b = vim.fn.getpos(".")
  local srow, scol, erow, ecol
  if a[2] < b[2] or (a[2] == b[2] and a[3] <= b[3]) then
    srow, scol, erow, ecol = a[2], a[3], b[2], b[3]
  else
    srow, scol, erow, ecol = b[2], b[3], a[2], a[3]
  end
  return srow, scol, erow, ecol
end

local function wrap_selection(open, close, vmode)
  local buf = 0
  local srow, scol, erow, ecol = visual_range()

  if vmode == "V" then
    -- Linewise: put delimiters on their own lines around the block.
    vim.api.nvim_buf_set_lines(buf, erow, erow, false, { close })
    vim.api.nvim_buf_set_lines(buf, srow - 1, srow - 1, false, { open })
    -- Content now lives on srow+1 .. erow+1 (1-based).
    return srow + 1, 1, erow + 1, 1
  end

  -- Charwise/block: end column is 1-based and inclusive, so the 0-based
  -- insert position for the close delimiter is exactly ecol.
  local end_line = vim.api.nvim_buf_get_lines(buf, erow - 1, erow, false)[1] or ""
  local insert_at = math.min(ecol, #end_line)
  -- Insert the closing delimiter first so earlier offsets stay valid.
  vim.api.nvim_buf_set_text(buf, erow - 1, insert_at, erow - 1, insert_at, { close })
  vim.api.nvim_buf_set_text(buf, srow - 1, scol - 1, srow - 1, scol - 1, { open })
  -- Inner content (1-based, inclusive). On a single line the open delimiter
  -- shifts everything after it by one, so the close end moves +1.
  local cc = (srow == erow) and (insert_at + 1) or insert_at
  return srow, scol + 1, erow, cc
end

map("x", "<leader>W", function()
  -- mode() is reliable here; visualmode() is empty during the callback.
  local vmode = vim.fn.mode()
  local char = vim.fn.nr2char(vim.fn.getchar())
  local pair = wrap_pairs[char]
  if not pair then
    return
  end
  local ar, ac, cr, cc = wrap_selection(pair[1], pair[2], vmode)

  -- Leave visual mode, then reselect the wrapped content explicitly.
  -- Do NOT use a bare `normal! gv`: the '< / '> marks still point at the
  -- previous selection, which made the cursor jump back to an earlier wrap.
  local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "nx", false)
  vim.fn.setpos("'<", { 0, ar, ac, 0 })
  vim.fn.setpos("'>", { 0, cr, cc, 0 })
  vim.cmd("normal! gv")
end, { desc = "Wrap selection" })

-- Buffer
local function buf_delete(force)
  local buf = vim.api.nvim_get_current_buf()
  local listed = vim.fn.getbufinfo(buf)[1].listed
  local others = 0
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if b ~= buf and vim.fn.buflisted(b) == 1 then
      others = others + 1
    end
  end
  if others == 0 then
    vim.notify("Last buffer", vim.log.levels.WARN)
    return
  end
  local cmd = force and "bdelete!" or "bdelete"
  vim.cmd(cmd .. " " .. buf)
end

map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Prev buffer" })
map("n", "<leader>bd", function()
  buf_delete(false)
end, { desc = "Delete buffer" })
map("n", "<leader>bD", function()
  buf_delete(true)
end, { desc = "Force delete buffer" })
map("n", "<leader>bl", "<cmd>buffer #<CR>", { desc = "Last buffer" })

-- Tabpage（内置 tabline）
map("n", "<leader>Tn", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<leader>Tc", "<cmd>tabclose<CR>", { desc = "Close tab" })
map("n", "<leader>TC", "<cmd>tabonly<CR>", { desc = "Close other tabs" })
map("n", "<leader>T]", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<leader>T[", "<cmd>tabprevious<CR>", { desc = "Prev tab" })

-- Window
map("n", "<leader>w|", "<cmd>vsplit<CR>", { desc = "Split vertically" })
map("n", "<leader>w-", "<cmd>split<CR>", { desc = "Split horizontally" })
map("n", "<leader>wc", "<cmd>close<CR>", { desc = "Close window" })
map("n", "<leader>wo", "<cmd>only<CR>", { desc = "Close other windows" })
map("n", "<leader>wO", "<cmd>only!<CR>", { desc = "Close other windows (force)" })

-- Window resize: Ctrl+arrows always move the shared divider in the arrow's
-- direction, no matter which side of the split the cursor is on (Vim's
-- <C-w>+/-/</> resize the *current window*, so the divider visually moves
-- the opposite way when you're in the right/bottom half). A count resizes
-- further: 5<C-Right> moves the divider 5 cells.
local function win_rect(win)
  local pos = vim.api.nvim_win_get_position(win)
  local row, col = pos[1], pos[2]
  return {
    top = row,
    left = col,
    bottom = row + vim.api.nvim_win_get_height(win) - 1,
    right = col + vim.api.nvim_win_get_width(win) - 1,
  }
end

-- Does a normal (non-floating) window sit directly left of / above {win}?
local function has_neighbor(win, side)
  local cur = win_rect(win)
  for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if w ~= win and vim.api.nvim_win_get_config(w).relative == "" then
      local r = win_rect(w)
      if side == "left" then
        if r.right < cur.left and r.bottom >= cur.top and r.top <= cur.bottom then
          return true
        end
      else -- "up"
        if r.bottom < cur.top and r.right >= cur.left and r.left <= cur.right then
          return true
        end
      end
    end
  end
  return false
end

-- move: +1 = right/down, -1 = left/up (direction the divider should travel)
local function resize(move, vertical)
  return function()
    local win = vim.api.nvim_get_current_win()
    -- If the neighbor is on the left/top, shrinking grows the divider in the
    -- requested direction; otherwise growing does.
    local flip = has_neighbor(win, vertical and "up" or "left")
    local delta = (flip and -1 or 1) * move * vim.v.count1
    if vertical then
      vim.cmd(string.format("resize %+d", delta))
    else
      vim.cmd(string.format("vertical resize %+d", delta))
    end
  end
end

map("n", "<C-Up>", resize(-1, true), { desc = "Move horizontal divider up" })
map("n", "<C-Down>", resize(1, true), { desc = "Move horizontal divider down" })
map("n", "<C-Left>", resize(-1, false), { desc = "Move vertical divider left" })
map("n", "<C-Right>", resize(1, false), { desc = "Move vertical divider right" })
map("n", "<leader>w=", "<C-w>=", { desc = "Equalize windows" })

-- Move lines up/down (VSCode-like Alt+j/k)
map("n", "<A-j>", "<cmd>silent! m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>silent! m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":silent! m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":silent! m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("i", "<A-j>", "<Esc>:silent! m .+1<CR>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<Esc>:silent! m .-2<CR>==gi", { desc = "Move line up" })
