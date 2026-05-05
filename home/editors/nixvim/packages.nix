{ pkgs, ... }:

{
  # 安装 Verible (SystemVerilog LSP) 和 Ctags
  home.packages = with pkgs; [
    verible
    universal-ctags
    metals
    haskell-language-server
    statix
    ruff
    chafa
  ];
}
