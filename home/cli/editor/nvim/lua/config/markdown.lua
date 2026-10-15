local api = vim.api
local ns = api.nvim_create_namespace("md-render")
local enabled = true

local hl_links = {
	H1 = "@markup.heading.1.markdown",
	H2 = "@markup.heading.2.markdown",
	H3 = "@markup.heading.3.markdown",
	H4 = "@markup.heading.4.markdown",
	H5 = "@markup.heading.5.markdown",
	H6 = "@markup.heading.6.markdown",
	H1Bg = "DiffText",
	H2Bg = "DiffAdd",
	H3Bg = "DiffChange",
	H4Bg = "DiffDelete",
	H5Bg = "Visual",
	H6Bg = "CursorColumn",
	Code = "ColorColumn",
	CodeInfo = "@label",
	Bullet = "Normal",
	Dash = "LineNr",
	Quote = "@markup.quote",
	Link = "@markup.link.label.markdown_inline",
	WikiLink = "RenderMarkdownLink",
	Unchecked = "@markup.list.unchecked",
	Checked = "@markup.list.checked",
	Todo = "@markup.raw",
	TableHead = "@markup.heading",
	TableRow = "Normal",
	Success = "DiagnosticOk",
	Info = "DiagnosticInfo",
	Hint = "DiagnosticHint",
	Warn = "DiagnosticWarn",
	Error = "DiagnosticError",
}

local function set_hls()
	for name, link in pairs(hl_links) do
		api.nvim_set_hl(0, "RenderMarkdown" .. name, { link = link, default = true })
	end
	-- borders are drawn with half blocks in the code background color
	local code = api.nvim_get_hl(0, { name = "RenderMarkdownCode", link = false })
	api.nvim_set_hl(0, "RenderMarkdownCodeBorder", { fg = code.bg })
end

local heading_icons = { "󰲡", "󰲣", "󰲥", "󰲧", "󰲩", "󰲫" }
local heading_sign = "󰫎"
local bullets = { "●", "○", "◆", "◇" }
local checkboxes = {
	[" "] = { "󰄱", "RenderMarkdownUnchecked" },
	x = { "󰱒", "RenderMarkdownChecked" },
	X = { "󰱒", "RenderMarkdownChecked" },
	["-"] = { "󰥔", "RenderMarkdownTodo" },
}
-- key -> { icon, highlight suffix }, the title is the capitalized key
local callouts = {
	note = { "󰋽", "Info" },
	tip = { "󰌶", "Success" },
	important = { "󰅾", "Hint" },
	warning = { "󰀪", "Warn" },
	caution = { "󰳦", "Error" },
	abstract = { "󰨸", "Info" },
	summary = { "󰨸", "Info" },
	tldr = { "󰨸", "Info" },
	info = { "󰋽", "Info" },
	todo = { "󰗡", "Info" },
	hint = { "󰌶", "Success" },
	success = { "󰄬", "Success" },
	check = { "󰄬", "Success" },
	done = { "󰄬", "Success" },
	question = { "󰘥", "Warn" },
	help = { "󰘥", "Warn" },
	faq = { "󰘥", "Warn" },
	attention = { "󰀪", "Warn" },
	failure = { "󰅖", "Error" },
	fail = { "󰅖", "Error" },
	missing = { "󰅖", "Error" },
	danger = { "󱐌", "Error" },
	error = { "󱐌", "Error" },
	bug = { "󰨰", "Error" },
	example = { "󰉹", "Hint" },
	quote = { "󱆨", "Quote" },
	cite = { "󱆨", "Quote" },
}
-- first match on the link destination wins
local link_icons = {
	{ "youtube%.com", "󰗃 " },
	{ "github%.com", "󰊤 " },
	{ "neovim%.io", "NEOVIM_ICON" },
	{ "stackoverflow%.com", "󰓌 " },
	{ "discord%.com", "󰙯 " },
	{ "reddit%.com", "󰑍 " },
	{ "^http", "󰖟 " },
}
local link_default = "󰌹 "
local link_image = "󰥶 "
local link_email = "󰀓 "
local link_wiki = "󱗖 "

local queries = nil
local function get_queries()
	if queries == nil then
		local ok_md, md = pcall(
			vim.treesitter.query.parse,
			"markdown",
			[[
			(atx_heading) @heading
			(fenced_code_block) @code
			(thematic_break) @dash
			[(list_marker_minus) (list_marker_plus) (list_marker_star)] @bullet
			(block_quote) @quote
			(pipe_table) @table
			]]
		)
		local ok_inline, inline = pcall(
			vim.treesitter.query.parse,
			"markdown_inline",
			[[
			[(inline_link) (full_reference_link) (image) (email_autolink) (uri_autolink)] @link
			(shortcut_link) @wiki
			]]
		)
		queries = { markdown = ok_md and md or nil, markdown_inline = ok_inline and inline or nil }
	end
	return queries
end

-- Keep fence rows addressable while their borders are drawn in place.
local function disable_fence_line_conceal()
	local ok, query = pcall(vim.treesitter.query.get, "markdown", "highlights")
	if not ok or not query then
		return false
	end
	local total, disabled = 0, 0
	for pattern, directives in pairs(query.info.patterns) do
		for _, directive in ipairs(directives) do
			if directive[1] == "set!" and directive[2] == "conceal_lines" then
				total = total + 1
				if pcall(query.query.disable_pattern, query.query, pattern) then
					disabled = disabled + 1
				end
				break
			end
		end
	end
	return total > 0 and total == disabled
end

local fence_conceal_disabled = disable_fence_line_conceal()

local function line(ctx, row)
	local text = ctx.lines[row]
	if not text then
		text = api.nvim_buf_get_lines(ctx.buf, row, row + 1, false)[1] or ""
		ctx.lines[row] = text
	end
	return text
end

local function mark(ctx, row, col, opts)
	opts.strict = false
	pcall(api.nvim_buf_set_extmark, ctx.buf, ns, row, col, opts)
end

local function conceal(ctx, row, col, len, char, hl)
	mark(ctx, row, col, { end_col = col + len, conceal = char, hl_group = hl })
end

-- Last row a block node covers: block nodes end at column 0 of the next row.
local function last_row(node)
	local _, _, erow, ecol = node:range()
	return ecol == 0 and erow - 1 or erow
end

local function depth(node, type)
	local n, p = 0, node:parent()
	while p do
		if p:type() == type then
			n = n + 1
		end
		p = p:parent()
	end
	return n
end

local function devicon(lang)
	local ok, devicons = pcall(require, "nvim-web-devicons")
	if not ok then
		return nil
	end
	return devicons.get_icon_by_filetype(vim.filetype.match({ filename = "a." .. lang }) or lang)
end

local handlers = {}

function handlers.heading(ctx, node)
	local row, col = node:start()
	local marker = node:child(0)
	local level = marker and tonumber(marker:type():match("^atx_h(%d)_marker$"))
	if not level then
		return
	end
	local hl = "RenderMarkdownH" .. level
	mark(ctx, row, col, {
		end_col = col + level,
		conceal = heading_icons[level],
		hl_group = hl,
		line_hl_group = hl .. "Bg",
		sign_text = heading_sign,
		sign_hl_group = hl,
	})
end

function handlers.code(ctx, node)
	local srow = node:start()
	local erow = last_row(node)
	local lang
	for child in node:iter_children() do
		if child:type() == "info_string" and child:named_child(0) then
			lang = vim.treesitter.get_node_text(child:named_child(0), ctx.buf)
		end
	end
	local last = node:named_child(node:named_child_count() - 1)
	local closed = last ~= nil and last:type() == "fenced_code_block_delimiter" and last:start() > srow
	if lang ~= "diff" then
		for row = srow, erow do
			mark(ctx, row, 0, { line_hl_group = "RenderMarkdownCode" })
		end
	end
	if not ctx.conceal or not fence_conceal_disabled then
		return
	end

	local width = math.max(ctx.width, 0)
	if width == 0 then
		return
	end
	local function border(row, chunks)
		if ctx.cur == row then
			return
		end
		conceal(ctx, row, 0, #line(ctx, row), "", "RenderMarkdownCode")
		mark(ctx, row, 0, { virt_text = chunks, virt_text_pos = "overlay", hl_mode = "replace" })
	end

	if ctx.cur ~= srow then
		local chunks
		if lang then
			local icon, icon_hl = devicon(lang)
			local label = " " .. (icon and icon .. " " or "") .. lang
			chunks = {
				{ "▄", "RenderMarkdownCodeBorder" },
				{ label, { "RenderMarkdownCode", icon_hl or "RenderMarkdownCodeInfo" } },
				{
					string.rep("▄", math.max(width - 1 - vim.fn.strdisplaywidth(label), 0)),
					"RenderMarkdownCodeBorder",
				},
			}
		else
			chunks = { { string.rep("▄", width), "RenderMarkdownCodeBorder" } }
		end
		border(srow, chunks)
	end
	if closed and ctx.cur ~= erow then
		border(erow, { { string.rep("▀", width), "RenderMarkdownCodeBorder" } })
	end
end

function handlers.dash(ctx, node)
	local row, col = node:start()
	if row == ctx.cur then
		return
	end
	mark(ctx, row, col, {
		virt_text = { { string.rep("─", ctx.width - col), "RenderMarkdownDash" } },
		virt_text_pos = "overlay",
	})
end

function handlers.bullet(ctx, node)
	local row, col = node:start()
	local _, mend = node:end_()
	local text = line(ctx, row)
	-- task box right after the marker: "- [ ] ", "- [x] ", "- [-] ";
	-- the marker node can include trailing spaces
	local rest = text:sub(mend + 1)
	local bs, be, key = rest:find("%[(.)%]")
	local box = checkboxes[key or ""]
	local after = be and rest:sub(be + 1, be + 1)
	if box and bs and rest:sub(1, bs - 1):match("^%s*$") and (after == "" or after == " ") then
		return conceal(ctx, row, col, mend + be - col, box[1], box[2])
	end
	local level = depth(node, "list")
	conceal(ctx, row, col, 1, bullets[(level - 1) % #bullets + 1], "RenderMarkdownBullet")
end

function handlers.quote(ctx, node)
	local srow, erow = node:start(), last_row(node)
	local level = depth(node, "block_quote") + 1
	local hl = "RenderMarkdownQuote"
	local first = line(ctx, srow)
	local prefix, key = first:match("^([%s>]*)%[!(%a+)%]")
	local callout = key and callouts[key:lower()]
	if callout then
		hl = "RenderMarkdown" .. callout[2]
		conceal(ctx, srow, #prefix, #key + 3, "", hl)
		if srow ~= ctx.cur then
			local title = key:sub(1, 1):upper() .. key:sub(2):lower()
			mark(ctx, srow, #prefix, { virt_text = { { callout[1] .. " " .. title, hl } }, virt_text_pos = "inline" })
		end
	end
	-- replace the ">" belonging to this quote level on every row
	for row = srow, erow do
		local n = 0
		for col in line(ctx, row):match("^[%s>]*"):gmatch("()>") do
			n = n + 1
			if n == level then
				conceal(ctx, row, col - 1, 1, "▋", hl)
				break
			end
		end
	end
end

local function strip_boundary_marker(s, marker)
	while s:sub(1, #marker) == marker do
		s = s:sub(#marker + 1)
	end
	while #s >= #marker and s:sub(-#marker) == marker do
		s = s:sub(1, -#marker - 1)
	end
	return s
end

local function strip_paired_marker(s, marker)
	local pattern = vim.pesc(marker)
	local previous
	repeat
		previous = s
		s = s:gsub(pattern .. "([^%s].-)" .. pattern, "%1")
	until s == previous
	return s
end

local function protect_code_spans(s, escaped)
	local parts, pos = {}, 1
	while true do
		local first, last = s:find("`+", pos)
		if not first then
			parts[#parts + 1] = s:sub(pos)
			break
		end
		parts[#parts + 1] = s:sub(pos, first - 1)
		local fence = s:sub(first, last)
		local close_start, close_end = s:find(fence, last + 1, true)
		if not close_start then
			parts[#parts + 1] = s:sub(first)
			break
		end
		escaped[#escaped + 1] = s:sub(last + 1, close_start - 1)
		parts[#parts + 1] = "\1" .. #escaped .. "\2"
		pos = close_end + 1
	end
	return table.concat(parts)
end

local function decode_html_entities(s)
	local named = {
		amp = "&",
		apos = "'",
		gt = ">",
		lt = "<",
		nbsp = " ",
		quot = '"',
	}
	return (
		s:gsub("&([^;]+);", function(entity)
			local hex = entity:match("^#[xX](%x+)$")
			local decimal = entity:match("^#(%d+)$")
			local code = hex and tonumber(hex, 16) or decimal and tonumber(decimal, 10)
			if code then
				local ok, char = pcall(vim.fn.nr2char, code, 1)
				return ok and char or "&" .. entity .. ";"
			end
			return named[entity] or "&" .. entity .. ";"
		end)
	)
end

-- Convert a Markdown cell to the text shown by the renderer.
local function plain_text(s)
	s = s:gsub("^%s+", ""):gsub("%s+$", "")
	local escaped = {}
	local escape_count = 0
	s = s:gsub("\\(.)", function(char)
		escape_count = escape_count + 1
		escaped[escape_count] = char
		return "\1" .. escape_count .. "\2"
	end)
	s = protect_code_spans(s, escaped)
	s = s:gsub("%s+", " ")
	s = s:gsub("!?%[([^%]]*)%]%b()", "%1")
	s = s:gsub("%[%[([^%]]+)%]%]", "%1")
	s = s:gsub("!?%[([^%]]*)%]%[([^%]]*)%]", "%1")
	s = s:gsub("!?%[([^%]]*)%]", "%1")
	s = s:gsub("<!--.-%-%->", " ")
	s = s:gsub("<([^<>]+)>", function(inner)
		if inner:match("^%a[%w+.-]*://") or inner:match("^[^%s@]+@[^%s@]+$") then
			return inner
		end
		if inner:match("^%s*img%s") then
			return inner:match('^%s*img%s+.-alt%s*=%s*"([^"]*)"') or inner:match("^%s*img%s+.-alt%s*=%s*'([^']*)'") or ""
		end
		return inner:lower():match("^%s*br%s*/?%s*$") and " " or ""
	end)
	s = decode_html_entities(s)
	s = strip_paired_marker(s, "*")
	s = strip_boundary_marker(s, "*")
	s = strip_paired_marker(s, "_")
	s = strip_boundary_marker(s, "_")
	s = strip_paired_marker(s, "~~")
	s = strip_boundary_marker(s, "~~")
	s = s:gsub("\1(%d+)\2", function(index)
		return escaped[tonumber(index)]
	end)
	return (s:gsub("\t", " "))
end

local function visible_width(s)
	return vim.fn.strdisplaywidth(plain_text(s))
end

local function cell_alignment(cell, buf)
	local text = vim.treesitter.get_node_text(cell, buf)
	local left = text:match("^%s*:") ~= nil
	local right = text:match(":%s*$") ~= nil
	if left and right then
		return "center"
	elseif right then
		return "right"
	end
	return "left"
end

local function pad_cell(text, width, alignment)
	local pad = math.max(width - visible_width(text), 0)
	local left, right
	if alignment == "right" then
		left, right = pad, 0
	elseif alignment == "center" then
		left = math.floor(pad / 2)
		right = pad - left
	else
		left, right = 0, pad
	end
	return string.rep(" ", left) .. plain_text(text) .. string.rep(" ", right)
end

function handlers.table(ctx, node)
	local rows = {}
	for child in node:iter_children() do
		local type = child:type()
		if type == "pipe_table_header" or type == "pipe_table_delimiter_row" or type == "pipe_table_row" then
			local cells, alignments = {}, {}
			for cell in child:iter_children() do
				if cell:type() == "pipe_table_cell" or cell:type() == "pipe_table_delimiter_cell" then
					cells[#cells + 1] = vim.treesitter.get_node_text(cell, ctx.buf)
					if type == "pipe_table_delimiter_row" then
						alignments[#alignments + 1] = cell_alignment(cell, ctx.buf)
					end
				end
			end
			local row, col = child:start()
			col = math.max(col, line(ctx, row):match("^%s*"):len())
			rows[#rows + 1] = { row = row, col = col, type = type, cells = cells, alignments = alignments }
		end
	end
	if #rows == 0 then
		return
	end

	-- A table is renderable when its header has at least one cell. Outer pipes are
	-- optional in Markdown, so they must not decide whether columns can align.
	local column_count = #rows[1].cells
	local aligned = column_count > 0
	local widths = {}
	for _, r in ipairs(rows) do
		if r.type ~= "pipe_table_delimiter_row" then
			for i, cell in ipairs(r.cells) do
				if i <= column_count then
					widths[i] = math.max(widths[i] or 0, visible_width(cell))
				end
			end
		end
	end
	if not aligned or not ctx.conceal then
		return
	end
	local table_col = rows[1].col
	local alignments = {}
	for _, r in ipairs(rows) do
		if r.alignments[1] then
			alignments = r.alignments
			break
		end
	end
	ctx.table_rows = ctx.table_rows or {}
	for _, r in ipairs(rows) do
		ctx.table_rows[r.row] = true
	end
	local function row_text(r)
		local delim = r.type == "pipe_table_delimiter_row"
		local pieces = { delim and "├" or "│" }
		for i, width in ipairs(widths) do
			if delim then
				pieces[#pieces + 1] = string.rep("─", width + 2)
				pieces[#pieces + 1] = i == column_count and "┤" or "┼"
			else
				local cell = pad_cell(r.cells[i] or "", width, alignments[i] or "left")
				pieces[#pieces + 1] = " " .. cell .. " "
				pieces[#pieces + 1] = "│"
			end
		end
		return table.concat(pieces)
	end

	for _, r in ipairs(rows) do
		-- the grid replaces the source text, so it is only safe on the cursor line
		-- when 'concealcursor' hides that line as well
		if ctx.conceal and (r.row ~= ctx.cur or ctx.conceal_cur) then
			local text = line(ctx, r.row)
			conceal(
				ctx,
				r.row,
				table_col,
				#text - table_col,
				"",
				r.type == "pipe_table_row" and "RenderMarkdownTableRow" or "RenderMarkdownTableHead"
			)
			mark(ctx, r.row, table_col, {
				virt_text = {
					{ row_text(r), r.type == "pipe_table_row" and "RenderMarkdownTableRow" or "RenderMarkdownTableHead" },
				},
				virt_text_pos = "overlay",
				hl_mode = "replace",
			})
		end
	end

	local function border(left, mid, right)
		local parts = {}
		for i, width in ipairs(widths) do
			parts[i] = string.rep("─", width + 2)
		end
		return left .. table.concat(parts, mid) .. right
	end
	mark(
		ctx,
		rows[1].row,
		table_col,
		{ virt_lines = { { { border("┌", "┬", "┐"), "RenderMarkdownTableHead" } } }, virt_lines_above = true }
	)
	mark(
		ctx,
		rows[#rows].row,
		table_col,
		{ virt_lines = { { { border("└", "┴", "┘"), "RenderMarkdownTableRow" } } } }
	)
end

function handlers.link(ctx, node)
	local row, col = node:start()
	if row == ctx.cur or (ctx.table_rows and ctx.table_rows[row]) then
		return
	end
	local type, icon = node:type(), link_default
	if type == "image" then
		icon = link_image
	elseif type == "email_autolink" then
		icon = link_email
	else
		local dest = node
		for child in node:iter_children() do
			if child:type() == "link_destination" then
				dest = child
			end
		end
		local url = vim.treesitter.get_node_text(dest, ctx.buf):gsub("^<", "")
		for _, custom in ipairs(link_icons) do
			if url:find(custom[1]) then
				icon = custom[2]
				break
			end
		end
	end
	mark(ctx, row, col, { virt_text = { { icon, "RenderMarkdownLink" } }, virt_text_pos = "inline" })
end

-- [[page]] parses as a shortcut link wrapped in one more pair of brackets
function handlers.wiki(ctx, node)
	local row, col = node:start()
	if ctx.table_rows and ctx.table_rows[row] then
		return
	end
	local _, ecol = node:end_()
	local text = line(ctx, row)
	if col == 0 or text:sub(col, col) ~= "[" or text:sub(ecol + 1, ecol + 1) ~= "]" then
		return
	end
	conceal(ctx, row, col - 1, 1, "", "RenderMarkdownWikiLink")
	conceal(ctx, row, ecol, 1, "", "RenderMarkdownWikiLink")
	if row ~= ctx.cur then
		mark(ctx, row, col - 1, { virt_text = { { link_wiki, "RenderMarkdownWikiLink" } }, virt_text_pos = "inline" })
	end
end

-- 'concealcursor' lists the modes in which the cursor line is concealed too
local function conceals_cursor_line(win)
	local cocu = vim.wo[win].concealcursor
	if cocu == "" then
		return false
	end
	local mode = api.nvim_get_mode().mode:sub(1, 1)
	if mode == "v" or mode == "V" or mode == "\22" or mode == "s" or mode == "S" then
		mode = "v"
	end
	return cocu:find(mode, 1, true) ~= nil
end

local function render(buf)
	if not api.nvim_buf_is_valid(buf) or vim.bo[buf].filetype ~= "markdown" then
		return
	end
	api.nvim_buf_clear_namespace(buf, ns, 0, -1)
	local wins = vim.fn.win_findbuf(buf)
	if not enabled or #wins == 0 then
		return
	end
	local parser = vim.treesitter.get_parser(buf, "markdown", { error = false })
	if not parser then
		return
	end
	local cur_win = api.nvim_get_current_win()
	local win = vim.tbl_contains(wins, cur_win) and cur_win or wins[1]
	-- only the visible rows of every window showing the buffer, plus a margin
	local top, bot = math.huge, 0
	for _, w in ipairs(wins) do
		local info = vim.fn.getwininfo(w)[1]
		top, bot = math.min(top, info.topline - 1), math.max(bot, info.botline)
	end
	top, bot = math.max(top - 100, 0), bot + 100
	parser:parse({ top, bot })

	local info = vim.fn.getwininfo(win)[1]
	local ctx = {
		buf = buf,
		lines = {},
		cur = win == cur_win and api.nvim_win_get_cursor(win)[1] - 1 or -1,
		width = info.width - info.textoff,
		conceal = vim.wo[win].conceallevel > 0,
		conceal_cur = win == cur_win and conceals_cursor_line(win),
	}
	local qs = get_queries()
	parser:for_each_tree(function(tree, ltree)
		local query = qs[ltree:lang()]
		local root = tree:root()
		local srow, _, erow = root:range()
		if not query or erow < top or srow > bot then
			return
		end
		for id, node in query:iter_captures(root, buf, top, bot) do
			pcall(handlers[query.captures[id]], ctx, node)
		end
	end)
end

local pending_timers = {}
local pending_scheduled = {}

local function schedule(buf, delay)
	if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].filetype ~= "markdown" then
		return
	end
	local timer = pending_timers[buf]
	if timer then
		timer:stop()
		timer:close()
		pending_timers[buf] = nil
	end
	if delay == 0 then
		pending_scheduled[buf] = true
		vim.schedule(function()
			if pending_scheduled[buf] then
				pending_scheduled[buf] = nil
				render(buf)
			end
		end)
		return
	end

	pending_scheduled[buf] = nil
	pending_timers[buf] = vim.defer_fn(function()
		pending_timers[buf] = nil
		render(buf)
	end, delay or 150)
end

local render_group = api.nvim_create_augroup("md-render", { clear = true })
local cursor_rows = {}

set_hls()
api.nvim_create_autocmd("ColorScheme", { group = render_group, callback = set_hls })

api.nvim_create_autocmd({ "FileType", "BufWinEnter", "InsertLeave" }, {
	group = render_group,
	callback = function(ev)
		schedule(ev.buf, 0)
	end,
})

api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
	group = render_group,
	callback = function(ev)
		schedule(ev.buf, 150)
	end,
})

api.nvim_create_autocmd({ "WinScrolled", "WinResized", "OptionSet" }, {
	group = render_group,
	callback = function(ev)
		if ev.event == "OptionSet" and ev.match ~= "conceallevel" and ev.match ~= "concealcursor" then
			return
		end
		for _, win in ipairs(api.nvim_tabpage_list_wins(0)) do
			schedule(api.nvim_win_get_buf(win), 0)
		end
	end,
})

-- re-render only when the cursor changes rows, to reveal the new cursor line
api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
	group = render_group,
	callback = function(ev)
		local row = api.nvim_win_get_cursor(0)[1]
		if cursor_rows[ev.buf] ~= row then
			cursor_rows[ev.buf] = row
			schedule(ev.buf, 0)
		end
	end,
})

api.nvim_create_autocmd("BufWipeout", {
	group = render_group,
	callback = function(ev)
		cursor_rows[ev.buf] = nil
		pending_scheduled[ev.buf] = nil
		local timer = pending_timers[ev.buf]
		if timer then
			timer:stop()
			timer:close()
			pending_timers[ev.buf] = nil
		end
	end,
})

-- Markdown preview use cli mdserve
local mdserve_job = nil
vim.keymap.set("n", "<leader>mp", function()
	if mdserve_job then
		vim.fn.jobstop(mdserve_job) -- stop previous mdserve
	end

	local file = vim.fn.expand("%:p")
	if file == "" then
		vim.notify("No file to preview", vim.log.levels.WARN)
		return
	end
	mdserve_job = vim.fn.jobstart({ "mdserve", file, "--port", "1337", "--open" }, { detach = true })
end, { desc = "Markdown preview (mdserve)" })

-- Native image preview: shows the image under the cursor with the builtin vim.ui.img.
-- Needs the kitty graphics protocol (kitty, ghostty, wezterm). Non-PNG local files
-- (webp, jpeg, gif) are converted to PNG with macOS sips before display.
local img_group = vim.api.nvim_create_augroup("md-img-preview", { clear = true })
local img_supported = nil -- nil until the terminal has been probed
local img_cache = {} -- path -> png bytes
local img_shown = nil -- { id, path }

local function img_clear()
	if img_shown then
		pcall(vim.ui.img.del, img_shown.id)
		img_shown = nil
	end
end

local function img_place(path, data)
	local win = vim.api.nvim_get_current_win()
	local pos = vim.api.nvim_win_get_position(win)
	-- img row/col are absolute terminal cells, so offset from the window position
	local row = pos[1] + vim.fn.winline() - 1 + (vim.wo[win].winbar ~= "" and 1 or 0)
	local width = math.floor(vim.fn.winwidth(win) * 0.3)
	local col = math.max(pos[2] + vim.fn.winwidth(win) - width - 1, pos[2] + 1)
	-- width only: kitty derives the height from the image aspect ratio
	local opts = { row = row, col = col, width = width }
	if img_shown and img_shown.path == path then
		vim.ui.img.set(img_shown.id, opts)
		return
	end
	img_clear()
	img_shown = { id = vim.ui.img.set(data, opts), path = path }
end

-- Convert any local image to PNG bytes. Direct passthrough for PNGs.
local function img_png_bytes(path)
	local ok, data = pcall(vim.fn.readblob, path)
	if not ok then
		return nil
	end
	if data:sub(1, 4) == "\137PNG" then
		return data
	end
	local out = vim.fn.tempname()
	vim.fn.system({ "sips", "-s", "format", "png", "--out", out, path })
	if vim.v.shell_error ~= 0 or vim.fn.filereadable(out) ~= 1 then
		return nil
	end
	data = vim.fn.readblob(out)
	vim.fn.delete(out)
	return data
end

local function img_show(path)
	if img_cache[path] then
		return img_place(path, img_cache[path])
	end
	if path:match("^https?://") then
		vim.net.request(path, {}, function(err, res)
			local data = type(res) == "table" and res.body
			if err or type(data) ~= "string" or data:sub(1, 4) ~= "\137PNG" then
				return
			end
			img_cache[path] = data
			vim.schedule(function()
				if vim.bo.filetype == "markdown" then
					img_place(path, data)
				end
			end)
		end)
	else
		local data = img_png_bytes(path)
		if not data then
			return
		end
		img_cache[path] = data
		img_place(path, data)
	end
end

vim.api.nvim_create_autocmd({ "CursorMoved", "WinScrolled" }, {
	group = img_group,
	callback = function()
		if not enabled or vim.bo.filetype ~= "markdown" then
			img_clear()
			return
		end
		-- Markdown ![alt](url) or HTML <img src="url">
		local path = vim.api.nvim_get_current_line():match("!%b[]%((%S+)%)")
			or vim.api.nvim_get_current_line():match('<img%s+src="([^"]+)"')
		if path and not path:match("^%a+://") then
			if path:sub(1, 1) == "~" then
				path = vim.env.HOME .. path:sub(2)
			elseif path:sub(1, 1) ~= "/" then
				path = vim.fs.joinpath(vim.fn.expand("%:p:h"), path)
			end
		end
		if not path or (not path:match("^%a+://") and vim.fn.filereadable(path) ~= 1) then
			img_clear()
			return
		end
		if img_supported == nil then
			local ok, supported = pcall(function()
				return require("vim.ui.img._kitty").supported({ timeout = 300 })
			end)
			img_supported = ok and supported == true
		end
		if img_supported then
			img_show(path)
		end
	end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
	group = img_group,
	callback = img_clear,
})

-- Clean up mdserve process when exiting nvim
vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		if mdserve_job then
			vim.fn.jobstop(mdserve_job)
		end
		pcall(vim.ui.img.del, math.huge)
	end,
})

vim.keymap.set("n", "<leader>um", function()
	enabled = not enabled
	for _, buf in ipairs(api.nvim_list_bufs()) do
		api.nvim_buf_clear_namespace(buf, ns, 0, -1)
		schedule(buf)
	end
	if not enabled then
		img_clear()
	end
	vim.notify("Markdown rendering " .. (enabled and "on" or "off"))
end, { desc = "Toggle render markdown" })

