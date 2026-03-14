{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;

    userName = "pomid0rko_0";
    userEmail = "lev55i@ya.ru";

    delta = {
      enable = true;
      options = {
        line-numbers = true;
      };
    };

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.autocrlf = "input";
    };
  };
}
