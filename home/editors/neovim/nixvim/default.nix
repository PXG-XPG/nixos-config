{ pkgs, inputs, ... }:

{
  # 导入 nixvim 的 home-manager 模块
  imports = [ inputs.nixvim.homeModules.nixvim ];

  # nixvim 依赖的外部工具
  home.packages = with pkgs; [
  ];

  programs.nixvim = {
    enable = true;

    # nvim 设置为默认编辑器
    defaultEditor = true;

    # 绑定vim/vi/vimdiff命令
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # 全局 vim 选项, Lua 代码
    extraConfigLua = ''
      -- 基本外观和行为
      vim.opt.number = true                     -- 在当前行左侧显示绝对行号
      vim.opt.relativenumber = true             -- 显示相对行号, 便于计算行号差进行跳转
      vim.opt.signcolumn = "yes"                -- 始终显示符号列，避免文本抖动
      vim.opt.cursorline = true                 -- 高亮显示当前行

      -- 缩进
      vim.opt.expandtab = true                  -- 按 Tab 键时插入空格，而不是真正的 \t 字符
      vim.opt.shiftwidth = 2                    -- 使用 >>、<<、== 等命令缩进时的宽度为 2 个空格
      vim.opt.tabstop = 2                       -- 一个 Tab 字符显示为 2 个空格宽
      vim.opt.smartindent = true                -- 根据代码结构自动缩进

      -- 搜索
      vim.opt.ignorecase = true                 -- 搜索时忽略大小写
      vim.opt.smartcase = true                  -- 如果搜索模式包含大写字母，则区分大小写
      vim.opt.hlsearch = true                   -- 高亮显示搜索结果

      -- 其他常用
      vim.opt.termguicolors = true              -- 启用终端的真彩色支持
      vim.opt.mouse = "a"                       -- 启用鼠标支持，所有模式下均可使用鼠标
      vim.opt.updatetime = 300                  -- 减少等待时间，提高响应速度
      vim.opt.timeoutlen = 1000                 -- 键盘映射等待时间
      vim.opt.scrolloff = 8                     -- 光标上下保留 8 行

      -- Leader 键设为空格
      vim.g.mapleader = ' '                     -- 把全局 leader 键设为空格键
      vim.g.maplocalleader = ' '                -- 把局部(buffer 级)leader 键也设为空格键
    '';

    # 剪贴板集成
    clipboard = {
      # Use system clipboard
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };
  };
}
