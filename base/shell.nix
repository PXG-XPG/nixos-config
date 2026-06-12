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
      hx = "hx -c /etc/nixos/base/editor/helix.toml";
      ".." = "cd ..";
      "..." = "cd ../..";
      "-" = "cd -";
    };
  };
}
