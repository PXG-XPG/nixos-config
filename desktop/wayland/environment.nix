{ ... }:
{
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XMODIFIERS = "@im=fcitx";
    MOZ_ENABLE_WAYLAND = "1";   # 新增:让 Zen/Firefox 走原生 Wayland
  };
}
