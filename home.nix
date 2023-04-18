{ config, pkgs, ... }:
let 
  pkgs = import <nixpkgs> { };
  fullpath = pkgs.runCommand "realpath" { } ''
  mkdir -p $out/bin $out/share
  cp ${pkgs.coreutils}/bin/realpath $out/bin/realpath 
  '';
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
    comma
    kubectl
    aws-vault
    awscli2
    ripgrep
    fzf
    docker
    gum
    gh
  ];

  /* NEOVIM */
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  /* GIT */
  programs.git = {
    enable = true;
  };

  /* SHELL */
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true; 
    initExtra = ''
        source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
    '';
    initExtraFirst = "source ~/.config/zsh/.zshrc";
    envExtra = ''
      alias ailo-tools="nix run git+ssh://git@github.com/ailohq/ailo-tools.git"
      change-profile() { eval $(ailo-tools shell_change_profile) ; }
      change-namespace() { eval $(ailo-tools shell_change_namespace) ; }
    ''; 
  };

  /* TERM */
  programs.kitty = {
    enable = true;
    font = {
      name = "Fantasque Sans Mono";
      size = 38;
    };
    /* theme = "Tokyo Night Storm"; */
    keybindings = {
      "cmd+l" = "select_tab";
      "ctrl+q" = "goto_tab 0";
      "cmd+shift+enter" = "new_window_with_cwd";
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
      background_opacity = "0.8";
      hide_window_decorations = "yes";
    };
  };

  programs = {
    k9s.enable = true;
    direnv.enable = true;
    nix-index.enable = true;
    bat.enable = true;
  };

  home.sessionVariables = {
    /* EDITOR = "nvim"; */
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
