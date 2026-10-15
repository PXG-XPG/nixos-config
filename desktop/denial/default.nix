{ inputs, ... }:
{
  imports = [
    # Denial 官方 NixOS 模块：自动注册 Wayland session、xdg portal、
    # Xwayland、polkit、rtkit、systemd 用户单元、CJK 字体等。
    inputs.denial.nixosModules.default
  ];

  programs.denial = {
    enable = true;
    polkitAgent.enable = true;
    ddc.enable = true;
    plugins.enable = true; # Optional Plugin Manager.
    engine.buildFromSource = false;
  };

  # Denial 的二进制缓存：随本模块生效，不再写进 basic/nix.nix。
  nix.settings = {
    extra-substituters = [ "https://denial.cachix.org" ];
    extra-trusted-public-keys = [
      "denial.cachix.org-1:wd8YTnvPmugFrtdMJWtR1XdVknR3/g2nmBJkT+vAruo="
    ];
  };
}
