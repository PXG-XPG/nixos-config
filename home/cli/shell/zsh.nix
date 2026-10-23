{ config, pkgs, commonAliases, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    autocd = true;
    autosuggestion = {
      enable = true;
      strategy = [ "history" "completion" ];
    };
    defaultKeymap = "emacs";
    shellAliases = commonAliases;
    fastSyntaxHighlighting = {
      enable = true;
      settings = {
        "chroma-," = "→chroma/-precommand.ch";
        chroma-comma = "→chroma/-precommand.ch";
        use_brackets = "0";
      };
    };

    history = {
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
      share = true;
      extended = true;
      size = 50000;
      save = 50000;
      ignorePatterns = [ "* --password*" "* *token*" ];
    };

    setOptions = [
      "HIST_REDUCE_BLANKS"
      "HIST_SAVE_NO_DUPS"
      "HIST_FIND_NO_DUPS"
      "NO_BEEP"
    ];

    plugins = [
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

    sessionVariables = {
      STARSHIP_CONFIG = "${config.home.homeDirectory}/.config/tokyo-night.toml";
    };

    # 在这里添加自定义 zshrc 内容
    initContent = ''
      if [[ $SHLVL -eq 1 ]]; then
        fastfetch
      fi

      # 让 <C-s> 透传给程序（禁用 XOFF 流控），供 nvim 保存用
      stty -ixon

      autoload -Uz edit-command-line
      zle -N edit-command-line
      bindkey '^x^e' edit-command-line

      sudo-command-line() {
        [[ -z $BUFFER ]] && LBUFFER="$(fc -ln -1)"
        if [[ $BUFFER == sudo\ * ]]; then
          LBUFFER="''${LBUFFER#sudo }"
        else
          LBUFFER="sudo $LBUFFER"
        fi
      }
      zle -N sudo-command-line
      bindkey '\es' sudo-command-line

      bindkey '^[[H' beginning-of-line
      bindkey '^[[F' end-of-line
      bindkey '^[OH' beginning-of-line
      bindkey '^[OF' end-of-line
      bindkey '^[[1~' beginning-of-line
      bindkey '^[[4~' end-of-line
    '';
  };
}
