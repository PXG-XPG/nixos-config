{ pkgs, commonAliases, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = commonAliases;

    plugins = [
      {
        name = "autopair";
        inherit (pkgs.fishPlugins.autopair) src;
      }
    ];

    # 仅在交互式 shell 执行
    interactiveShellInit = ''
      if test "$SHLVL" -eq 1
        fastfetch
      end
      set -g fish_greeting ""

      # 让 <C-s> 透传给程序（禁用 XOFF 流控），供 nvim 保存用
      stty -ixon
    '';

    # 非交互也需要（starship 会读取），放在 shellInit
    shellInit = ''
      set -gx STARSHIP_CONFIG $HOME/.config/gruvbox-rainbow.toml
    '';
  };
}
