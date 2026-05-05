{
  programs.nixvim.extraConfigVim = ''
    set completeopt=menu,menuone,noselect
    set signcolumn=yes
  '';
}
