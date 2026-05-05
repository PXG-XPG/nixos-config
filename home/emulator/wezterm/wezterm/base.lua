local constants = require("constants")

return function(wezterm, config)
	-- theme
	wezterm.add_to_config_reload_watch_list(wezterm.config_dir .. "/colors/dank-theme.toml")
	config.color_scheme = "dank-theme"

	-- shell
	config.default_prog = { "zsh" }

	-- window
	config.window_background_opacity = constants.OPACITY
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
	-- config.font = wezterm.font_with_fallback({ "0xProto Nerd Font", "LXGW Neo ZhiSong Screen" })
	config.font = wezterm.font_with_fallback({ "0xProto Nerd Font", "Maple Mono NF CN" })
	config.font_size = 16

	-- cursor
	config.default_cursor_style = "BlinkingBar"
	config.animation_fps = 165

	-- Render front-end
	config.front_end = "OpenGL"
	config.enable_wayland = true

	-- general
	check_for_updates = false
	exit_behavior = "CloseOnCleanExit"

	-- hyperlink rules
	hyperlink_rules = {
    -- Matches: a URL in parens: (URL)
    {
      regex = "\\((\\w+://\\S+)\\)",
      format = "$1",
      highlight = 1,
    },
    -- Matches: a URL in brackets: [URL]
    {
      regex = "\\[(\\w+://\\S+)\\]",
      format = "$1",
      highlight = 1,
    },
    -- Matches: a URL in curly braces: {URL}
    {
      regex = "\\{(\\w+://\\S+)\\}",
      format = "$1",
      highlight = 1,
    },
    -- Matches: a URL in angle brackets: <URL>
    {
      regex = "<(\\w+://\\S+)>",
      format = "$1",
      highlight = 1,
    },
    -- Then handle URLs not wrapped in brackets
    {
      regex = "\\b\\w+://\\S+[)/a-zA-Z0-9-]+",
      format = "$0",
    },
    -- implicit mailto link
    {
      regex = "\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b",
      format = "mailto:$0",
    },
  }
end
