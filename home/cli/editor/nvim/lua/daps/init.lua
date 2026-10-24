-- DAP 入口：安装 nvim-dap / nvim-dap-ui / nvim-nio，
-- 加载各语言适配器配置，注册统一键位、UI 自动开关。
-- 各语言适配器放在本目录下，每个文件一个语言。

vim.pack.add({
  { src = "https://github.com/mfussenegger/nvim-dap", version = "0.10.0" },
  { src = "https://github.com/rcarriga/nvim-dap-ui", version = "v4.0.0" },
  { src = "https://github.com/nvim-neotest/nvim-nio" },
})

local dap = require("dap")
local dapui = require("dapui")

dapui.setup()

-- UI 跟随调试会话自动开关
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

-- 自动发现同目录下的语言适配器（排除 init.lua），字母序加载
local dir = vim.fn.stdpath("config") .. "/lua/daps"
local names = {}
for name in vim.fs.dir(dir) do
  if name:sub(-4) == ".lua" and name ~= "init.lua" then
    names[#names + 1] = (name:gsub("%.lua$", ""))
  end
end
table.sort(names)

for _, name in ipairs(names) do
  require("daps." .. name)
end

-- 键位
local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc })
end

map("n", "<leader>db", function()
  dap.toggle_breakpoint()
end, "Toggle breakpoint")
map("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, "Set conditional breakpoint")
map("n", "<leader>dc", function()
  dap.continue()
end, "Continue / start")
map("n", "<leader>dC", function()
  dap.run_to_cursor()
end, "Run to cursor")
map("n", "<leader>di", function()
  dap.step_into()
end, "Step into")
map("n", "<leader>do", function()
  dap.step_over()
end, "Step over")
map("n", "<leader>dO", function()
  dap.step_out()
end, "Step out")
map("n", "<leader>dt", function()
  dap.terminate()
end, "Terminate")
map("n", "<leader>dr", function()
  dap.repl.toggle()
end, "Toggle REPL")
map("n", "<leader>dl", function()
  dap.run_last()
end, "Run last")
map({ "n", "v" }, "<leader>de", function()
  dapui.eval()
end, "Evaluate expression")
map("n", "<leader>du", function()
  dapui.toggle()
end, "Toggle DAP UI")
