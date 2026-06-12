{ config, pkgs, ... }:
{
  xdg.configFile = {
    "fcitx5/profile" = {
      source = ./profile;
      # every time fcitx5 switch input method, it will modify ~/.config/fcitx5/profile,
      # so we need to force replace it in every rebuild to avoid file conflict.
      force = true;
    };
    "mozc/config1.db".source = ./mozc-config1.db;
    "fcitx5/conf/classicui.conf" = {
      source = ./classicui.conf;
      force = true;
    };
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        qt6Packages.fcitx5-configtool # GUI for fcitx5
        fcitx5-gtk # gtk im module
        fcitx5-rime # for flypy chinese input method

        # Japanese
        # ctrl-i / F7 - convert to takakana
        # ctrl-u / F6 - convert to hiragana
        fcitx5-mozc-ut # Moze with UT dictionary

        fcitx5-hangul # Korean
        fcitx5-mellow-themes # Theme
      ];
    };
  };
}
