{ config, pkgs, lib, ...}:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    autocd = true;
    autosuggestion.enable = true;
    defaultKeymap = "emacs";

    history = {
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
      share = true;
      append = true;
      extended = true;
      save = 10000;
    };

    # 设置一些别名方便使用，你可以根据自己的需要进行增删
    shellAliases = {
      su = "su -";
      mv = "mv -i";
      cp = "cp -i";
      cls = "clear";
      grep = "grep --color=auto";
      ff = "fastfetch";
      ffall = "fastfetch -c all";
      ".." = "cd ..";
      "..." = "cd ../..";
    };

    plugins = [
      {
        name = "nix-zsh-completions";
        src = pkgs.nix-zsh-completions;
        file = "share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh";
        completions = [ "share/zsh/site-functions" ];
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
        file = "share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
      }
      {
        name = "autopair";
        inherit (pkgs.zsh-autopair) src;
        file = "zsh-autopair.plugin.zsh";
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
      {
        name = "zsh-fzf-history-search";
        src = pkgs.zsh-fzf-history-search;
        file = "share/zsh-fzf-history-search/zsh-fzf-history-search.plugin.zsh";
      }
    ];

    envExtra = ''
      export STARSHIP_CONFIG=~/.config/tokyo-night.toml      
    '';    

    # 在这里添加自定义 zshrc 内容
    initContent = lib.mkMerge [
      # Workaround for home-manager#2562: completions from home.packages aren't in fpath
      (lib.mkOrder 561 ''
        fpath+=("${config.home.profileDirectory}"/share/zsh/site-functions \
                "${config.home.profileDirectory}"/share/zsh/$ZSH_VERSION/functions \
                "${config.home.profileDirectory}"/share/zsh/vendor-completions)
      '')
      ''
        fastfetch

        autoload -Uz edit-command-line
        zle -N edit-command-line
        bindkey '^x^e' edit-command-line
      ''
    ];
  };
}
