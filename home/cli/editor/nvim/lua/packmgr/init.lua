-- 插件管理入口：基于 Neovim 内置的 vim.pack API（install/update/delete/list）。
-- 提供：更新全部插件、卸载插件、查看插件列表、重启生效。
-- 键位前缀 <leader>P*（大写 P；小写 <leader>p 已被 yanky 占用）。
--
-- 安装插件的方式：在 lua/plugins/<name>.lua 里写 vim.pack.add 声明，
-- 重启后自动安装；本模块不负责创建配置文件。
-- 卸载只删磁盘与锁文件，不动 lua/plugins/*.lua 声明。

local M = {}

local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc })
end

-- 插件清单：名称 / 版本 / rev / 来源
function M.plugin_list()
  local rows = {}
  for _, p in ipairs(vim.pack.get(nil, { info = false })) do
    rows[#rows + 1] = {
      name = p.spec.name,
      version = p.spec.version or "-",
      rev = (p.rev or ""):sub(1, 8),
      src = p.spec.src or "",
      path = p.path,
    }
  end
  table.sort(rows, function(a, b)
    return a.name < b.name
  end)
  return rows
end

-- fzf 条目：name \t version \t rev \t src
local function to_entry(row)
  return string.format("%s\t%s\t%s\t%s", row.name, row.version, row.rev, row.src)
end

local function parse_name(entry)
  return (entry or ""):match("^([^\t]+)")
end

-- 通用插件选择器
function M.pick(prompt, on_confirm)
  local rows = M.plugin_list()
  if #rows == 0 then
    vim.notify("No plugins managed by vim.pack", vim.log.levels.WARN)
    return
  end
  local by_name = {}
  for _, row in ipairs(rows) do
    by_name[row.name] = row
  end

  require("fzf-lua").fzf_exec(function(cb)
    for _, row in ipairs(rows) do
      cb(to_entry(row))
    end
    cb(nil)
  end, {
    fzf_opts = {
      ["--prompt"] = prompt .. "> ",
      ["--delimiter"] = "\t",
      ["--header"] = "name  version  rev  src",
      ["--layout"] = "reverse",
    },
    actions = {
      ["default"] = function(selected)
        local entry = selected[1]
        if not entry then
          return
        end
        on_confirm(by_name[parse_name(entry)] or entry)
      end,
    },
  })
end

-- 查看插件列表
function M.list()
  M.pick("Plugin", function(row)
    if type(row) ~= "table" then
      return
    end
    vim.notify(
      ("%s\nversion: %s\nrev:     %s\nsrc:     %s\npath:    %s"):format(
        row.name,
        row.version,
        row.rev,
        row.src,
        row.path
      ),
      vim.log.levels.INFO
    )
  end)
end

-- 卸载插件
function M.delete()
  M.pick("Uninstall", function(row)
    if type(row) ~= "table" then
      return
    end
    local msg = ("Uninstall %s?\n\nRemoves the plugin from disk and the lockfile.\nThe lua/plugins/*.lua declaration is kept, so it will be\nreinstalled on the next start."):format(row.name)
    if vim.fn.confirm(msg, "&Yes\n&No", 2, "Uninstall plugin") ~= 1 then
      return
    end
    local ok, err = pcall(vim.pack.del, { row.name }, { force = true })
    if not ok then
      vim.notify("Failed to uninstall " .. row.name .. ": " .. tostring(err), vim.log.levels.ERROR)
      return
    end
    vim.notify(("Uninstalled %s. Run :restart to apply."):format(row.name), vim.log.levels.INFO)
  end)
end

-- 确认缓冲区是 nvim.pack 内部创建的，提示写在它顶部最不容易被错过。
-- 该行不以 "# " 开头，不会干扰 nvim.pack 对 "# Update"/"## <name>" 的解析。
local function hint_confirm_buf(text)
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[b].filetype == "nvim-pack" then
      vim.bo[b].modifiable = true
      vim.api.nvim_buf_set_lines(b, 0, 0, false, { text })
      vim.bo[b].modifiable = false
      return true
    end
  end
  return false
end

-- 更新全部插件（弹出确认缓冲区，:write 应用，:quit 放弃）
function M.update()
  local ok, err = pcall(vim.pack.update)
  if not ok then
    vim.notify("Update failed: " .. tostring(err), vim.log.levels.ERROR)
    return
  end
  hint_confirm_buf(
    "Apply with :write  ·  Discard with :quit  ·  ]] / [[ to switch plugin  ·  gra to skip a plugin"
  )
end

-- 强制更新全部插件（跳过确认缓冲区，直接 checkout 并写锁文件）
function M.update_force()
  local ok, err = pcall(vim.pack.update, nil, { force = true })
  if not ok then
    vim.notify("Update failed: " .. tostring(err), vim.log.levels.ERROR)
    return
  end
  vim.notify("Plugins updated. Run :restart to apply.", vim.log.levels.INFO)
end

-- 解析 nvim-pack.log 里最后一条「可回退」的更新记录。
-- 日志里可能有空条目（例如上次更新失败时写的），要从后往前跳过它们。
-- 返回 { [name] = { before = rev, after = rev } }
local function parse_last_update()
  local path = vim.fn.stdpath("log") .. "/nvim-pack.log"
  if vim.fn.filereadable(path) == 0 then
    return nil
  end
  local lines = vim.fn.readfile(path)

  -- 逐条切分记录
  local entries = {}
  local cur, cur_name
  for _, line in ipairs(lines) do
    if line:match("^========== Update ") then
      cur = {}
      entries[#entries + 1] = cur
      cur_name = nil
    elseif cur then
      local name = line:match("^## (.+)$")
      if name then
        cur_name = name:gsub(" %(not active%)$", "")
        cur[cur_name] = cur[cur_name] or {}
      elseif cur_name then
        local before = line:match("^Revision before:%s+([0-9a-f]+)")
        local after = line:match("^Revision after:%s+([0-9a-f]+)")
        if before then
          cur[cur_name].before = before
        end
        if after then
          cur[cur_name].after = after
        end
      end
    end
  end

  -- 从后往前找第一条真正含 "Revision before" 的记录
  for i = #entries, 1, -1 do
    local usable = false
    for _, r in pairs(entries[i]) do
      if r.before then
        usable = true
        break
      end
    end
    if usable then
      return entries[i]
    end
  end
  return nil
end

-- 改锁文件里指定插件的 rev（按行改写，保留原有缩进格式）
local function set_lock_revs(revs)
  local path = vim.fn.stdpath("config") .. "/nvim-pack-lock.json"
  if vim.fn.filereadable(path) == 0 then
    return {}
  end
  local lines = vim.fn.readfile(path)
  local changed = {}
  for i, line in ipairs(lines) do
    local name = line:match('^%s*"([^"]+)": {')
    if name and revs[name] then
      for j = i + 1, math.min(i + 6, #lines) do
        local pre, _, post = lines[j]:match('^(%s*"rev": ")([0-9a-f]+)(".*)$')
        if pre then
          lines[j] = pre .. revs[name] .. post
          changed[name] = revs[name]
          break
        end
      end
    end
  end
  if next(changed) then
    vim.fn.writefile(lines, path)
  end
  return changed
end

-- 把 git 的原始报错翻译成能看懂的话
local function describe_git_failure(name, out)
  local gone = out:match("not our ref")
    or out:match("could not get object")
    or out:match("not a tree object")
    or out:match("unable to read tree")
    or out:match("did not send all necessary objects")
  if gone then
    return ("%s: upstream no longer has this commit (force-pushed away) - cannot be reverted"):format(name)
  end
  return ("%s: %s"):format(name, vim.trim(out))
end

-- 插件安装目录
local function plugin_path(name)
  for _, p in ipairs(vim.pack.get(nil, { info = false })) do
    if p.spec.name == name then
      return p.path
    end
  end
end

-- 回退上一次更新。
--
-- 注意：vim.pack 的 lock_read() 会把锁文件**缓存在内存里**，同一 session 内再改磁盘上的
-- 锁文件是不生效的（plugin_lock 有值就直接 return）。所以这里不依赖
-- vim.pack.update(target='lockfile')，而是：
--   1. 直接 git checkout 回旧 rev
--   2. 改磁盘上的锁文件
--   3. 重启 nvim —— 让内存缓存与磁盘一致，同时让旧版插件代码生效
function M.revert()
  local revs = parse_last_update()
  if not revs or vim.tbl_isempty(revs) then
    vim.notify("No update found in nvim-pack.log", vim.log.levels.WARN)
    return
  end

  local rows = {}
  for name, r in pairs(revs) do
    if r.before then
      rows[#rows + 1] = { name = name, before = r.before, after = r.after or "" }
    end
  end
  if #rows == 0 then
    vim.notify("Last update has no revertable revision", vim.log.levels.WARN)
    return
  end
  table.sort(rows, function(a, b)
    return a.name < b.name
  end)

  local by_name = {}
  for _, row in ipairs(rows) do
    by_name[row.name] = row
  end

  require("fzf-lua").fzf_exec(function(cb)
    for _, row in ipairs(rows) do
      cb(string.format("%s\t%s\t%s", row.name, row.before:sub(1, 8), row.after:sub(1, 8)))
    end
    cb(nil)
  end, {
    fzf_opts = {
      ["--prompt"] = "Revert> ",
      ["--delimiter"] = "\t",
      ["--header"] = "name  revert-to  current",
      ["--layout"] = "reverse",
      ["--multi"] = "",
    },
    actions = {
      ["default"] = function(selected)
        if not selected[1] then
          return
        end
        local picked = {}
        for _, entry in ipairs(selected) do
          local name = entry:match("^([^\t]+)")
          if name and by_name[name] then
            picked[name] = by_name[name].before
          end
        end
        if vim.tbl_isempty(picked) then
          return
        end

        -- 1) git checkout 回旧 rev
        local failed = {}
        for name, rev in pairs(picked) do
          local path = plugin_path(name)
          if not path then
            failed[#failed + 1] = name .. " (not installed)"
          else
            vim.fn.system({ "git", "-C", path, "stash", "--quiet" })
            local out = vim.fn.system({ "git", "-C", path, "checkout", "--quiet", rev })
            if vim.v.shell_error ~= 0 then
              failed[#failed + 1] = describe_git_failure(name, out)
            else
              -- 与 vim.pack 的 checkout 保持一致：重新生成 helptags
              local doc = path .. "/doc"
              if vim.fn.isdirectory(doc) == 1 then
                vim.fn.delete(doc .. "/tags")
                pcall(vim.cmd.helptags, { doc, magic = { file = false } })
              end
            end
          end
        end
        if #failed > 0 then
          vim.notify("Revert failed: " .. table.concat(failed, "; "), vim.log.levels.ERROR)
          return
        end

        -- 2) 改磁盘上的锁文件
        local changed = set_lock_revs(picked)
        if vim.tbl_isempty(changed) then
          vim.notify("Failed to update nvim-pack-lock.json", vim.log.levels.ERROR)
          return
        end

        local names = vim.tbl_keys(changed)
        table.sort(names)
        -- 3) 重启：刷新内存里的锁文件缓存 + 让旧版插件代码生效
        vim.notify(("Reverted %s. Restarting..."):format(table.concat(names, ", ")), vim.log.levels.INFO)
        vim.defer_fn(function()
          vim.cmd("restart")
        end, 200)
      end,
    },
  })
end

-- 重启 nvim，让安装/更新/卸载生效
function M.restart()
  vim.cmd("restart")
end

-- 键位
map("n", "<leader>Pl", M.list, "Plugin list")
map("n", "<leader>Pd", M.delete, "Uninstall plugin")
map("n", "<leader>Pu", M.update, "Update all plugins")
map("n", "<leader>PU", M.update_force, "Force update all plugins")
map("n", "<leader>PR", M.revert, "Revert last update")
map("n", "<leader>Pr", M.restart, "Restart nvim")

return M
