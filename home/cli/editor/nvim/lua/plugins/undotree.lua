-- Built-in undo tree visualizer (package-undotree, shipped with nvim).
-- Dist plugin is not auto-loaded, so packadd it first.
vim.cmd.packadd("nvim.undotree")

local undotree = require("undotree")

-- Track whether we disabled treesitter on a buffer while undotree was open,
-- so we can re-enable it on close (handles both toggle and window close).
local ts_disabled_buf = nil

-- Buffer whose undo history the current tree window is displaying.
-- Needed because :undolist always acts on the *current* buffer, and inside
-- the tree window that is the scratch tree buffer, not your file.
local source_buf = nil

local function reopen_ts()
  if ts_disabled_buf and vim.api.nvim_buf_is_valid(ts_disabled_buf) then
    pcall(vim.treesitter.start, ts_disabled_buf)
  end
  ts_disabled_buf = nil
end

-- Run :undolist against the source buffer even though the tree window is
-- focused. nvim_buf_call() makes `buf` the current buffer for the command,
-- then we echo the captured output (ui2 collapses it to one line + [+N];
-- press <CR> to page through the whole listing).
local function show_source_undolist()
  local buf = source_buf
  if not (buf and vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf)) then
    vim.notify("undotree: source buffer not found", vim.log.levels.WARN)
    return
  end

  local ok, out = pcall(vim.api.nvim_buf_call, buf, function()
    return vim.fn.execute("undolist")
  end)
  if not ok then
    vim.notify("undotree: " .. tostring(out), vim.log.levels.ERROR)
    return
  end

  out = out:gsub("^\n+", ""):gsub("\n+$", "")
  vim.api.nvim_echo({ { out } }, true, {})
end

-- <Plug> keeps the Lua callback while still allowing a noremap buffer-local
-- mapping (nvim_buf_set_keymap has no `callback` field).
vim.keymap.set("n", "<Plug>(undotree-undolist)", show_source_undolist, {
  desc = "Show :undolist for undo-tree source buffer",
})

-- Toggle the undo tree window for the current buffer.
-- Moving the cursor inside the tree jumps to that undo state;
-- the tree redraws on TextChanged/InsertLeave.
--
-- Treesitter can throw "Index out of bounds" in nvim_buf_get_text while
-- re-highlighting after an undo (a known 0.12.x issue). Disable highlighting
-- on the source buffer while browsing, restore on close.
vim.keymap.set("n", "<leader>ut", function()
  local buf = vim.api.nvim_get_current_buf()
  local was_open = undotree.open() -- true if it was open (now closed)
  if was_open then
    source_buf = nil
    reopen_ts()
  else
    source_buf = buf
    if vim.treesitter.highlighter.active[buf] then
      pcall(vim.treesitter.stop, buf)
      ts_disabled_buf = buf
    else
      ts_disabled_buf = nil
    end
  end
end, { desc = "Toggle undo tree" })

-- Re-enable treesitter if the tree window is closed by other means
-- (e.g. <C-w>c / :close) rather than via the toggle keymap.
vim.api.nvim_create_autocmd("BufWipeout", {
  callback = function(ev)
    if vim.bo[ev.buf].filetype ~= "nvim-undotree" then
      return
    end
    source_buf = nil
    reopen_ts()
  end,
})

-- The tree buffer is nofile + modifiable=false, so u / CTRL-R would raise
-- E21 ("Cannot make changes, 'modifiable' is off"). Remap them to no-op;
-- navigation inside the tree is driven by cursor movement (CursorMoved).
vim.api.nvim_create_autocmd("FileType", {
  pattern = "nvim-undotree",
  callback = function(ev)
    -- Fallback for :Undotree / :lua require("undotree").open(): recover the
    -- paired source buffer from the split partner (works because the tree is
    -- opened as a vertical split of the source window).
    if not (source_buf and vim.api.nvim_buf_is_valid(source_buf)) then
      source_buf = nil
      local prev = vim.fn.win_getid(vim.fn.winnr("#"))
      if prev ~= 0 then
        local pb = vim.api.nvim_win_get_buf(prev)
        if pb ~= ev.buf and vim.bo[pb].filetype ~= "nvim-undotree" then
          source_buf = pb
        end
      end
    end

    -- NOTE: vim.keymap.set(..., { buffer = ev.buf }) silently lands on the
    -- wrong buffer here (ev.buf=2 but the map ends up in buffer 1). Use
    -- nvim_buf_set_keymap to target the buffer explicitly.
    vim.api.nvim_buf_set_keymap(ev.buf, "n", "u", "<Nop>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(ev.buf, "n", "<C-r>", "<Nop>", { noremap = true, silent = true })

    vim.api.nvim_buf_set_keymap(ev.buf, "n", "<leader>ul", "<Plug>(undotree-undolist)", {
      noremap = true,
      silent = true,
      desc = "Show :undolist for source buffer",
    })
  end,
})
