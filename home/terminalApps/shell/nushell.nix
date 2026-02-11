{ pkgs, ... }:

{
    programs.nushell = {
        enable = true;
        shellAliases = {
            mv = "mv -i";
            cp = "cp -i";
            cls = "clear";
            grep = "grep --color=auto";
            ff = "fastfetch";
            ffall = "fastfetch -c all";
            ".." = "cd ..";
            "..." = "cd ../..";
        };
        settings = {
            show_banner = false;
        };
        extraConfig= "
            fastfetch
        ";
        environmentVariables = {
            STARSHIP_CONFIG = "/home/rum/.config/catppuccin-powerline.toml";
        };
    };
}
