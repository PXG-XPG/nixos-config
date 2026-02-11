{ pkgs, ...}:

{
  home.packages = with pkgs; [ 
    zsh
    zsh-fzf-tab
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    defaultKeymap = "emacs";

    history = {
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
      append = true;
      extended = true;
    };

    # 设置一些别名方便使用，你可以根据自己的需要进行增删
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

    # 在这里添加自定义 zshrc 内容
    initContent = "
      fastfetch
      export STARSHIP_CONFIG=~/.config/tokyo-night.toml      
      export PATH=$PATH:~/.local/bin/
      export EDITOR=nvim
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
    ";
  };
}
