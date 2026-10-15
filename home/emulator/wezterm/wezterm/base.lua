local utils = require("utils")

return function(wezterm, config)
	-- theme
	-- wezterm.add_to_config_reload_watch_list(wezterm.config_dir .. "/colors/dank-theme.toml")
	config.color_scheme = "tokyonight_night"
	-- 鼠标选中区域：红底白字，醒目
	config.colors = {
		selection_bg = "#ff0000",
		selection_fg = "#ffffff",
	}

	-- shell
	config.default_prog = { "zsh" }

	-- window
	config.window_background_opacity = utils.OPACITY
	config.wayland_window_background_blur = true
	config.initial_cols = 100
	config.initial_rows = 28
	config.window_padding = {
		-- The gap between the tab bar and the window edge
		top = 0,
		bottom = 0,
	}

	-- Pane
	config.inactive_pane_hsb = {
		saturation = 0.9,
		brightness = 0.8,
	}

	-- font
	config.font = wezterm.font_with_fallback({ "JetBrainsMono Nerd Font", "LXGW WenKai Screen", "Twitter Color Emoji" })
	config.font_size = 16

	-- cursor
	config.default_cursor_style = "SteadyBar"
	-- config.animation_fps = 165

	-- Render front-end
	config.front_end = "OpenGL"
	config.enable_wayland = true

	-- general
	config.check_for_updates = false
	config.exit_behavior = "CloseOnCleanExit"
end
