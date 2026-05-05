{
  programs.nixvim.globals = {
    mapleader = " ";

    # Airline 扩展配置 (使用 # 符号的必须在 globals 中)
    "airline#extensions#tabline#enabled" = 1;
    "airline#extensions#tabline#formatter" = "unique_tail";
    "airline#extensions#tabline#buffer_nr_show" = 1;

    # Gutentags 配置
    gutentags_project_root = [".root" ".svn" ".git" ".hg" ".project"];
    gutentags_ctags_tagfile = ".tags";

    # NERDTree 配置
    NERDTreeQuitOnOpen = 1;
  };
}
