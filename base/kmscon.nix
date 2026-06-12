{ pkgs, ... }:
{
  services.kmscon = {
    enable = true;
    config = {
      hwaccel = true;
      font-size = 16;
      font-name = "Maple Mono NF CN";
    };
    extraOptions = "--term xterm-256color";
  };
}
