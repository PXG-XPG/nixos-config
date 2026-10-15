local utils = require("utils")

return function(wezterm, config)
	local scheme = wezterm.color.get_builtin_schemes()["tokyonight_night"]
	local back_color = scheme.background
	local fore_color = scheme.foreground

	local TAB_MAX_WIDTH = 999

	-- 整条 tab bar 的列数，不等于 pane 的 cols：
	-- tab bar 实际宽 = window.dimensions.pixel_width / cell 宽
	-- （即 termwindow/mod.rs 里的 title_width），已包含 window_padding 左右留白、
	-- 滚动条预留和边框，所以会比 cols 多出几列。用 像素/像素 换算，免去猜 padding。
	local function update_cols(window)
		local pane = window:active_pane():get_dimensions()
		local cols = pane.cols
		if pane.cols > 0 and pane.pixel_width > 0 then
			local win = window:get_dimensions()
			local cell = pane.pixel_width / pane.cols
			cols = math.floor(win.pixel_width / cell + 0.5)
		end
		wezterm.GLOBAL.cols = cols
	end

	config.use_fancy_tab_bar = false
	config.hide_tab_bar_if_only_one_tab = true
	config.tab_bar_at_bottom = false
	config.show_new_tab_button_in_tab_bar = false
	config.tab_max_width = TAB_MAX_WIDTH

	-- 合并而非覆盖，避免冲掉 base.lua 里设置的 selection 等颜色
	config.colors = config.colors or {}
	config.colors.tab_bar = {
		background = utils.hex_to_rgba("#000000", utils.OPACITY),
		active_tab = {
			bg_color = utils.hex_to_rgba(back_color, utils.OPACITY),
			fg_color = utils.hex_to_rgba(scheme.ansi[5], 1.0),
			intensity = "Bold",
			italic = true,
		},
		inactive_tab = {
			bg_color = utils.hex_to_rgba(back_color, utils.OPACITY),
			fg_color = utils.hex_to_rgba(fore_color, utils.OPACITY),
		},
		inactive_tab_hover = {
			bg_color = utils.hex_to_rgba(back_color, utils.OPACITY),
			fg_color = utils.hex_to_rgba(fore_color, utils.OPACITY),
		},
	}

	wezterm.on("window-config-reloaded", update_cols)
	wezterm.on("window-resized", function(window, _)
		update_cols(window)
	end)

	wezterm.on("format-tab-title", function(tab, tabs, panes, cfg, hover, max_width)
		local full_title = (tab.tab_index + 1) .. ": " .. tab.active_pane.title
		local len = wezterm.column_width(full_title)

		-- pass 1：wezterm 用 tab_max_width 探测长度，只返回原始标题，
		-- 否则会污染它对整条 bar 容量的估算。
		if max_width >= TAB_MAX_WIDTH then
			return full_title
		end

		local n = #tabs
		local target

		-- pass 2 有两种情况：
		-- a) max_width == 原始标题宽度 ⇒ 标题总长放得下，wezterm 不再钳制，
		--    可把整条 bar 的列数精确等分给每个 tab（余数分给前几个），零空隙。
		-- b) 放不下 ⇒ max_width 是 wezterm 给的每 tab 上限
		--    floor((bar-(n-1))/n)（它多留给 retro 并不绘制的分隔符），
		--    直接按该上限等宽，避免被二次裁剪。
		if max_width == len then
			local total = wezterm.GLOBAL.cols or 80
			local base = math.floor(total / n)
			target = base + (tab.tab_index < (total % n) and 1 or 0)
		else
			target = max_width
		end

		if len >= target then
			return wezterm.truncate_right(full_title, target)
		end
		local pad = target - len
		local left = math.floor(pad / 2)
		return string.rep(" ", left) .. full_title .. string.rep(" ", pad - left)
	end)
end
