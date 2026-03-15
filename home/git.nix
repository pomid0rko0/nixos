{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user.name = "pomid0rko_0";
      user.email = "lev55i@ya.ru";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.autocrlf = "input";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      line-numbers = true;
    };
  };
}
