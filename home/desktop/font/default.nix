{ ... }:
{
  fonts = {
    fontconfig = {
      # defaultFonts（serif/sansSerif/monospace/emoji）已由系统级 basic/fonts.nix 统一管理，
      # 这里不再重复维护同一份列表。

      configFile = {
        # 让Fontconfig正确获取系统级配置的字体
        nix = {
          enable = true;
          priority = 99;
          label = "nix";
          text = ''
            <?xml version="1.0"?>
            <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
            <fontconfig>
              <!-- NIX_PROFILE is the path to your Nix profile. See Nix Reference Manual for details. -->
              <dir prefix="cwd">NIX_PROFILE/lib/X11/fonts</dir>
              <dir prefix="cwd">NIX_PROFILE/share/fonts</dir>
            </fontconfig>
          '';
        };
      };
    };
  };
}
