{ ... }:
{
  programs.bash = {
    enable = true;
    completion.enable = true;
    shellAliases = {
      su = "su -";
      y = "yazi";
      mv = "mv -i";
      cp = "cp -i";
      cls = "clear";
      grep = "grep --color=auto";
      hx = "hx -c /etc/nixos/base/editor/helix.toml";
      ".." = "cd ..";
      "..." = "cd ../..";
      "-" = "cd -";
    };
  };
}
