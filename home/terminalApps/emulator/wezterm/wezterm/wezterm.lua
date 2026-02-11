local wezterm = require("wezterm")
local config = wezterm.config_builder()

require("base")(wezterm, config)
require("binds")(wezterm, config)
require("tab")(wezterm, config)

return config
