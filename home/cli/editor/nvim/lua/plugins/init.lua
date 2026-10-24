local dir = vim.fn.stdpath("config") .. "/lua/plugins"

local names = {}
for name in vim.fs.dir(dir) do
  if name:sub(-4) == ".lua" and name ~= "init.lua" then
    names[#names + 1] = (name:gsub("%.lua$", ""))
  end
end
table.sort(names) -- 字母序加载；需要固定顺序可用数字前缀，如 00-plenary.lua

for _, name in ipairs(names) do
  require("plugins." .. name)
end
