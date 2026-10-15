local M = {}

local function listed()
	return vim
		.iter(vim.api.nvim_list_bufs())
		:filter(function(buf)
			return vim.bo[buf].buflisted and vim.api.nvim_buf_get_name(buf) ~= ""
		end)
		:totable()
end

-- Terminals report themselves as modified forever but have nothing to save.
local function unsaved(buf)
	return vim.bo[buf].modified and vim.bo[buf].buftype == ""
end

local function survivor(doomed)
	local cur = vim.api.nvim_get_current_buf()
	if not doomed[cur] and vim.bo[cur].buflisted then
		return cur
	end
	local alt = vim.fn.bufnr("#")
	if alt > 0 and vim.api.nvim_buf_is_valid(alt) and not doomed[alt] and vim.bo[alt].buflisted then
		return alt
	end
	for _, buf in ipairs(listed()) do
		if not doomed[buf] then
			return buf
		end
	end
	return vim.api.nvim_create_buf(true, false)
end

---@param targets integer[]
---@param force boolean? discard unsaved changes instead of keeping the buffer
function M.close(targets, force)
	local doomed, kept = {}, 0
	for _, buf in ipairs(targets) do
		if vim.api.nvim_buf_is_valid(buf) then
			if force or not unsaved(buf) then
				doomed[buf] = true
			else
				kept = kept + 1
			end
		end
	end

	if next(doomed) then
		-- Windows have to move off the doomed buffers first: otherwise Neovim
		-- picks each replacement itself and reads a file from disk that the next
		-- iteration deletes again.
		local keep = survivor(doomed)
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			if doomed[vim.api.nvim_win_get_buf(win)] then
				vim.api.nvim_win_set_buf(win, keep)
			end
		end
		for _, buf in ipairs(targets) do
			if doomed[buf] then
				pcall(vim.api.nvim_buf_delete, buf, { force = true })
			end
		end
	end

	if kept > 0 then
		vim.notify(kept .. " buffer(s) with unsaved changes kept", vim.log.levels.WARN)
	end
end

---@param side "left"|"right"|"other"
local function relative(side)
	local bufs = listed()
	local cur = vim.api.nvim_get_current_buf()
	local idx
	for i, buf in ipairs(bufs) do
		if buf == cur then
			idx = i
			break
		end
	end
	if not idx then
		return side == "other" and bufs or {}
	end
	if side == "left" then
		return vim.list_slice(bufs, 1, idx - 1)
	end
	if side == "right" then
		return vim.list_slice(bufs, idx + 1)
	end
	return vim.list_extend(vim.list_slice(bufs, 1, idx - 1), vim.list_slice(bufs, idx + 1))
end

local map = vim.keymap.set

map("n", "<Tab>", "<Cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<Cmd>bprevious<CR>", { desc = "Prev buffer" })
map("n", "<S-l>", "<Cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", "<Cmd>bprevious<CR>", { desc = "Prev buffer" })
map("n", "]b", "<Cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "[b", "<Cmd>bprevious<CR>", { desc = "Prev buffer" })
map("n", "<leader>bn", "<Cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<Cmd>bprevious<CR>", { desc = "Prev buffer" })
map("n", "<leader>bb", "<Cmd>buffer #<CR>", { desc = "Other buffer" })

map("n", "<leader>bd", function()
	M.close({ vim.api.nvim_get_current_buf() })
end, { desc = "Close buffer" })

map("n", "<leader>bD", function()
	M.close({ vim.api.nvim_get_current_buf() }, true)
end, { desc = "Close buffer (force)" })

map("n", "<leader>bo", function()
	M.close(relative("other"))
end, { desc = "Close other buffers" })

map("n", "<leader>bl", function()
	M.close(relative("left"))
end, { desc = "Close left buffers" })

map("n", "<leader>br", function()
	M.close(relative("right"))
end, { desc = "Close right buffers" })

map("n", "<leader>ba", function()
	M.close(listed())
end, { desc = "Close all buffers" })

-- Buffers (floating picker with preview)
map("n", "<leader>fb", function()
	local bufs = vim.fn.getbufinfo({ buflisted = 1, bufloaded = 1 })
	local items = {}
	for _, buf in ipairs(bufs) do
		table.insert(items, { name = vim.fn.bufname(buf.bufnr), bufnr = buf.bufnr })
	end
	require("config.picker").open(items, {
		title = "Buffers",
		skip_single = false,
		format = function(item)
			return item.name ~= "" and item.name or "[No Name]"
		end,
		preview = function(item, ctx)
			local lines = vim.api.nvim_buf_get_lines(item.bufnr, 0, -1, false)
			ctx.set_lines(lines, vim.bo[item.bufnr].filetype)
		end,
		on_confirm = function(item)
			vim.cmd("buffer " .. item.bufnr)
		end,
	})
end, { desc = "Buffers" })

return M

