{ lib, nixosConfig, ... }:
{
  imports = [
    ./fontconfig
    ./xdg
  ] ++ lib.optionals nixosConfig.programs.niri.enable [
    # 仅当桌面环境是 niri 时导入
    ./niri
  ];
}
