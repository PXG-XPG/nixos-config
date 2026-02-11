return function(wezterm, config)
	config.disable_default_key_bindings = true

	local act = wezterm.action

	-- Key bindings
	config.keys = {
		-- Copy and paste
		{ key = "w", mods = "ALT", action = act.CopyTo("Clipboard") },
		{ key = "y", mods = "CTRL", action = act.PasteFrom("Clipboard") },

		-- Tab
		{ key = "t", mods = "CTRL", action = act.SpawnTab("DefaultDomain") },
		{ key = "w", mods = "CTRL", action = act.CloseCurrentTab({ confirm = false }) },
		{ key = "]", mods = "CTRL", action = act.ActivateTabRelative(1) },
		{ key = "[", mods = "CTRL", action = act.ActivateTabRelative(-1) },

		-- Pane
		{ key = "|", mods = "SHIFT | ALT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "-", mods = "ALT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{ key = "H", mods = "ALT", action = act.ActivatePaneDirection("Left") },
		{ key = "L", mods = "ALT", action = act.ActivatePaneDirection("Right") },
		{ key = "K", mods = "ALT", action = act.ActivatePaneDirection("Up") },
		{ key = "J", mods = "ALT", action = act.ActivatePaneDirection("Down") },
		{ key = "LeftArrow", mods = "ALT", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "DownArrow", mods = "ALT", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "UpArrow", mods = "ALT", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "RightArrow", mods = "ALT", action = act.AdjustPaneSize({ "Right", 1 }) },

		-- Scroll
		{ key = "p", mods = "ALT", action = act.ScrollByLine(-1) },
		{ key = "n", mods = "ALT", action = act.ScrollByLine(1) },

		-- Copy mode
		{ key = "Space", mods = "CTRL", action = act.ActivateCopyMode },

		-- Quick select mode
		{ key = "Space", mods = "ALT | CTRL", action = act.QuickSelect },
	}

	-- Mouse bindings
	config.mouse_bindings = {
		-- copy the selection
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "NONE",
			action = act.CompleteSelection("ClipboardAndPrimarySelection"),
		},

		-- Open HyperLink
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = act.OpenLinkAtMouseCursor,
		},
	}

	-- ALT + number to activate that tab
	for i = 1, 9 do
		table.insert(config.keys, {
			key = tostring(i),
			mods = "ALT",
			action = act.ActivateTab(i - 1),
		})
	end
end
