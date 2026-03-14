{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
    shellAliases = {
      ll = "ls -la";
    };

    history = {
      size = 10000;
      ignoreAllDups = true;
    };
  };
}
