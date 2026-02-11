{ ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;

    # 在这里添加你的自定义 bashrc 内容
    bashrcExtra = ''
    '';

    shellAliases = {
      mv = "mv -i";
      cp = "cp -i";
      cls = "clear";
      grep = "grep --color=auto";
      ff = "fastfetch";
      ffall = "fastfetch -c all";
      ".." = "cd ..";
      "..." = "cd ../..";
    };
  };
}
