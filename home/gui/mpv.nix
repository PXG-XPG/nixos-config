{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto";
      vo = "gpu-next";
      autofit-larger = "100%x100%";
      save-position-on-quit = true;
    };
    defaultProfiles = [
      "gpu-hq"
    ];
    scripts = [ pkgs.mpvScripts.mpris ];
  };
}
