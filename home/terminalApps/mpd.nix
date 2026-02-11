{ ... }:

{
  services.mpd = {
    enable = true;
    musicDirectory = "/home/rum/Music";
    dataDir = "/home/rum/.mpd";
  };
}
