{ config, pkgs, ... }:
let 
  pkgs = import <nixpkgs> { };
  fullpath = pkgs.runCommand "realpath" { } ''
  mkdir -p $out/bin $out/share
  cp ${pkgs.coreutils}/bin/realpath $out/bin/realpath 
  '';
  fonts = { 
    FantasqueSansMono = {
        name = "FantasqueSansMono Nerd Font Mono";
        size = 40;
    };
    CaskaydiaNerdFontMono = {
        name = "CaskaydiaCove Nerd Font Mono";
        size = 40;
    };
  };
in
{
  home.username = "isaacrenner";
  home.homeDirectory = "/Users/isaacrenner";
  home.stateVersion = "22.11";
  /* FIX SOME BUG - forgot to log*/
  manual.manpages.enable = false;

  home.packages = with pkgs; [
    /* custom-dsv */
    fullpath
    /* nixpkgs */
    yarn # needed for js dev - tmp 
    jq # bash json parsing
    convco # Common commit
    comma # use programs using nix-index without installing
    kubectl # pain
    aws-vault # more pain
    awscli2 # endless suffering
    ripgrep # better grep
    fzf # fuzzy finder
    docker # source of most of my pain
    gum # prettier scripts
    zld #better linker
  ];

  programs = {
    /* NEOVIM */
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    /* GIT */
    git = {
      enable = true;
      aliases = {
        s = "switch";
        as = "add src";
        aa = "add .";
        st = "status -sb";
        ll = "log --oneline";
        last = "log -1 head --stat";
        d = "difftool -t vimdiff -y";
      };
      delta = {
        enable = true;
        options = {
          navigate = true;
          side-by-side = true;
          line-numbers = true;
          theme = "discord";
        };
      };
    };

    lazygit = {
      enable = true;
    };

    /* bindkey "^[[A" history-beginning-search-backward-end */
    /* bindkey "^[[B" history-beginning-search-forward-end */
    /* SHELL */
    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true; 
      completionInit = "autoload -Uz compinit && compinit";
      initExtra = ''
        source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5' 
        
        autoload -U history-beginning-search-backward
        autoload -U history-beginning-search-forward
        bindkey "^[[A" history-beginning-search-backward
        bindkey "^[[B" history-beginning-search-forward
        alias bk=", bk browse"

        alias commit="convco commit -i -- --no-edit"
        source ~/.config/zsh/.zshrc
        precmd () {
          print -Pn "\e]0;$(basename -s .git `git config --get remote.origin.url` 2> /dev/null || cwd)/$(git branch --show-current 2> /dev/null)\a"
        }
        '';
      envExtra = ''
        alias ailo-tools="nix run git+ssh://git@github.com/ailohq/ailo-tools.git"
        alias gt="nix run git+ssh://git@github.com/isaac-renner/git-tools.git"
        change-profile() { eval $(ailo-tools shell_change_profile) ; }
        change-namespace() { eval $(ailo-tools shell_change_namespace) ; }

        # source nix-darwin
        . /etc/static/bashrc
        export EDITOR="nvim"
      ''; 
    };

    /* TERM */
    kitty = {
      enable = true;
      font = fonts.CaskaydiaNerdFontMono;
      /* theme = "Tokyo Night Storm"; */
      keybindings = {
        "cmd+t" = "new_tab_with_cwd";
        "cmd+l" = "select_tab";
        "ctrl+q" = "goto_tab 0";
        "cmd+enter" = "new_window_with_cwd";
        "cmd+shift+enter" = "new_window";
        "ctrl+shift+1" = "goto_tab 1";
        "ctrl+shift+2" = "goto_tab 2";
        "ctrl+shift+3" = "goto_tab 3";
        "ctrl+shift+4" = "goto_tab 4";
        "ctrl+shift+5" = "goto_tab 5";
        "ctrl+shift+6" = "goto_tab 6";
      };
      extraConfig = ''
        include Tokyo Night Storm.conf      
        map f1 set_tab_title
        '';
      settings = {
        background_opacity        = "0.85";
        hide_window_decorations   = "yes";
        tab_title_template        =  "{index} {title}";
        active_tab_title_template =  "{index} {title}";
        active_tab_font_style     =  "normal";
        tab_bar_margin_height     =  "7.5 7.5";
        tab_bar_style             =  "powerline";
        tab_bar_align             =  "left";
        tab_bar_min_tabs          =  1;
        enabled_layouts           =  "fat,splits,stack";
      };
    };

    /* PROMPT */
    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        aliases ={
          r = "repo view --web";
          p = "pr view --web";
        };
      };
    };
 
    direnv.enable = true;
    nix-index.enable = true;
    bat.enable = true;

    /* UNCOMMENT THIS TO BE LESS PRODUCTIVE */
    /*vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
    }; */
  };

  home.sessionVariables = {
     EDITOR = "nvim"; 
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
