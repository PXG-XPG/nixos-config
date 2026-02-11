return function(wezterm, config)
    config.use_fancy_tab_bar = false
    config.hide_tab_bar_if_only_one_tab = true
    config.tab_bar_at_bottom = false
    config.show_new_tab_button_in_tab_bar = false
    config.tab_max_width = 999

    local function get_max_cols(window)
        local tab = window:active_tab()
        local cols = tab:get_size().cols
        return cols
    end

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
