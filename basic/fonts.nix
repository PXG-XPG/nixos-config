{ pkgs, ... }:
let
  # Mount options for the bind mounts
  mountOptions = [
    "ro"
    "x-gvfs-hide"
    # Resolves symlinks as if they were real files
    # Needed for things like OnlyOffice
    "resolve-symlinks"
  ];
in
{
  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;

    packages = with pkgs; [
      # 谷歌Noto Unicode码全覆盖
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji

      maple-mono.NF-CN
      nerd-fonts.jetbrains-mono

      # 中文字体
      source-han-mono
      source-han-sans
      source-han-serif
      lxgw-wenkai-screen

      # Twitter打造的emoji字体
      twitter-color-emoji
    ];

    fontconfig = {
      defaultFonts = {
        serif = [
          "Source Serif 4"
          # 中文: 宋体（港台称明體）
          "Source Han Serif SC" # 思源宋体
          "Source Han Serif TC"
        ];
        sansSerif = [
          # 西文: 无衬线字体（指笔画末端没有修饰(衬线)的字体，通常用于屏幕显示）
          "Source Sans 3"
          # 中文: 黑体
          "LXGW WenKai Screen" # 霞鹜文楷 屏幕阅读版
          "Source Han Sans SC" # 思源黑体
          "Source Han Sans TC"
        ];
        monospace = [
          # 中文
          "Maple Mono NF CN"
          "Source Han Mono SC" # 思源等宽
          "Source Han Mono TC"
          # 西文
          "JetBrainsMono Nerd Font"
        ];

        emoji = [
          "Twitter Color Emoji"
        ];
      };

      antialias = true; # 抗锯齿
      hinting.enable = false; # 禁止字体微调 - 高分辨率下没这必要
      subpixel = {
        rgba = "rgb"; # IPS 屏幕使用 rgb 排列
      };
    };
  };

  system.fsPackages = [ pkgs.bindfs ];

  # Fonts
  fileSystems."/usr/share/fonts" = {
    device = "/run/current-system/sw/share/X11/fonts";
    fsType = "fuse.bindfs";
    options = mountOptions;
  };

  # Icons
  fileSystems."/usr/share/icons" = {
    device = "/run/current-system/sw/share/icons";
    fsType = "fuse.bindfs";
    options = mountOptions;
  };

  # Themes
  fileSystems."/usr/share/themes" = {
    device = "/run/current-system/sw/share/themes";
    fsType = "fuse.bindfs";
    options = mountOptions;
  };
}
