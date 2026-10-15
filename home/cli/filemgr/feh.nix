{ ... }:
{
  programs.feh = {
    enable = true;
    themes = {
      feh = [
        "--image-bg" "black"
        "--geometry" "1100x650"
        "--scale-down"
      ];
    };
  };
}
