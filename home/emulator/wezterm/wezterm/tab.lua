local constants = require("constants")
local utils = require("utils")

return function(wezterm, config)
    local scheme = wezterm.color.load_scheme(wezterm.config_dir .. "/colors/dank-theme.toml")
    local back_color = scheme.background
    local fore_color = scheme.foreground

    local function get_max_cols(window)
        local tab = window:active_tab()
        local cols = tab:get_size().cols
        return cols
    end

    config.use_fancy_tab_bar = false
    config.hide_tab_bar_if_only_one_tab = true
    config.tab_bar_at_bottom = false
    config.show_new_tab_button_in_tab_bar = false
    config.tab_max_width = 999
    config.colors = {
        tab_bar = {
            background = utils.hex_to_rgba(back_color, constants.OPACITY),
            active_tab = {
                bg_color = utils.hex_to_rgba(back_color, constants.OPACITY),
                fg_color = utils.hex_to_rgba(scheme.ansi[5], 1.0),
                intensity = 'Bold',
                italic = true,
            },
            inactive_tab = {
                bg_color = utils.hex_to_rgba(back_color, constants.OPACITY),
                fg_color = utils.hex_to_rgba(fore_color, constants.OPACITY),
            },
            inactive_tab_hover = {
                bg_color = utils.hex_to_rgba(back_color, constants.OPACITY),
                fg_color = utils.hex_to_rgba(fore_color, constants.OPACITY),
            },
        },
    }

    wezterm.on(
        'window-config-reloaded',
        function(window)
            wezterm.GLOBAL.cols = get_max_cols(window)
        end
    )

    wezterm.on(
        'window-resized',
        function(window, pane)
            wezterm.GLOBAL.cols = get_max_cols(window)
        end
    )

    wezterm.on(
        'format-tab-title',
        function(tab, tabs, panes, config, hover, max_width)
            local title = tab.active_pane.title
            local full_title = tab.tab_index + 1 .. ": " .. title
            local pad_length = (wezterm.GLOBAL.cols // #tabs - #full_title) // 2
            if pad_length * 2 + #full_title > max_width then
                pad_length = (max_width - #full_title) // 2
            end
            return string.rep(' ', pad_length) .. full_title .. string.rep(' ', pad_length)
        end
    )
end
