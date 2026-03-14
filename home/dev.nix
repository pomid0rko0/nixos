{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      ms-python.python
    ];

    userSettings = {
      "editor.fontFamily" = "'JetBrains Mono', monospace";
      "editor.fontSize" = 14;
      "editor.formatOnSave" = true;
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
    };
  };

  home.packages = with pkgs; [
    nil      # Nix language server для nix-ide
    python3  # Python последней версии
  ];
}
