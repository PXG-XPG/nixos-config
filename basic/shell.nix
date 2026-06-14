{ ... }:
{
  programs.bash = {
    enable = true;
    completion.enable = true;
    shellAliases = {
      su = "su -";
      mv = "mv -i";
      y = "yazi";
      cp = "cp -i";
      cls = "clear";
      grep = "grep --color=auto";
      ".." = "cd ..";
      "..." = "cd ../..";
      "-" = "cd -";
    };
  };
}
