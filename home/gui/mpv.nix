{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto";
      vo = "gpu-next";
      save-position-on-quit = true;
    };
    defaultProfiles = [
      "gpu-hq"
    ];
    scripts = [ pkgs.mpvScripts.mpris ];
  };
}
