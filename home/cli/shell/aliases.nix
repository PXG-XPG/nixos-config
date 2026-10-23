{ ... }:
{
  # 所有 shell 共用的别名，改一处全生效
  _module.args.commonAliases = {
    su = "su -";
    mv = "mv -i";
    cp = "cp -i";
    cls = "clear";
    grep = "grep --color=auto";
    ff = "fastfetch";
    ffall = "fastfetch -c all";
    ".." = "cd ..";
    "..." = "cd ../..";
    scrcpy = "scrcpy --video-codec=h265 --max-size=1920 --max-fps=165 --keyboard=uhid";
  };
}
