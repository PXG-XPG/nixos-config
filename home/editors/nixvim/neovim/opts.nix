{
  programs.nixvim.opts = {
    number = true;
    relativenumber = true;
    tabstop = 4;
    shiftwidth = 4;
    expandtab = true;
    ignorecase = true;
    smartcase = true;
    mouse = "a";
    clipboard = "unnamedplus";
    hlsearch = true;
    incsearch = true;
    showcmd = true;
    autoindent = true;
    smartindent = true;
    laststatus = 2;
    cursorline = true;
    cursorcolumn = true;
    encoding = "utf-8";
    fileencoding = "utf-8";
    termguicolors = true;
    wildmenu = true;
    wildmode = "longest:full,full";
    timeoutlen = 500;
  };
}
