return function(wezterm, config)
	-- theme
	wezterm.add_to_config_reload_watch_list(wezterm.config_dir .. "/colors/dank-theme.toml")
        config.color_scheme = "dank-theme"

	-- shell
	config.default_prog = { "zsh" }

	-- window
	config.window_background_opacity = 0.8
	config.window_decorations = "NONE"
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
	config.font = wezterm.font_with_fallback({ "0xProto Nerd Font", "LXGW Neo ZhiSong Screen" })
	config.font_size = 15

	-- cursor
	config.default_cursor_style = "BlinkingBar"
	config.animation_fps = 165

	-- Render front-end
	config.front_end = "OpenGL"
	config.enable_wayland = false
end
