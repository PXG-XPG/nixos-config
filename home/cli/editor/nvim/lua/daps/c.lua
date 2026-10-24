-- C/C++ 调试适配器：lldb-dap（由 nixpkgs 的 lldb 包提供）
-- 学习/单文件场景通常先 gcc -g 编译出可执行文件，再在 nvim 里调试它。

local dap = require("dap")

dap.adapters.lldb = {
  type = "executable",
  command = "lldb-dap",
  name = "lldb",
}

local function cwd_executable()
  -- 默认取当前工作目录下的 a.out（gcc 默认输出名）
  local default = vim.fn.getcwd() .. "/a.out"
  local path = vim.fn.input({
    prompt = "Path to executable: ",
    default = default,
    completion = "file",
  })
  return (path ~= "") and path or dap.ABORT
end

local c_configs = {
  {
    name = "Launch (lldb-dap)",
    type = "lldb",
    request = "launch",
    program = cwd_executable,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
  },
}

dap.configurations.c = c_configs
dap.configurations.cpp = c_configs
