{ pkgs, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        # fcitx5-gtk # gtk im module
        kdePackages.fcitx5-chinese-addons
        # fcitx5-mozc-ut # Moze with UT dictionary
      ];
    };
  };
}
