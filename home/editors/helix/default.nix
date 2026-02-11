{ pkgs, ... }:

{
    programs.helix = {
        enable = true;
        extraPackages = with pkgs; [
            nil
            nixfmt
        ];
    };

    home.file.".config/helix" = {
        source = ./helix;
        recursive = true;
    };
}
