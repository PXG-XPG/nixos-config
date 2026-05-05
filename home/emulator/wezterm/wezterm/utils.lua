local M = {}

function M.hex_to_rgba(hex, alpha)
    local hex = hex:gsub("#", "")
    local r, g, b = tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
    return string.format("rgba(%d, %d, %d, %f)", r, g, b, alpha)
end

return M
