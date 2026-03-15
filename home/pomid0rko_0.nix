{ config, pkgs, ... }:

{
  imports = [
    ./shell.nix
    ./firefox.nix
    ./dev.nix
    ./git.nix
  ];

  home.username = "pomid0rko_0";
  home.homeDirectory = "/home/pomid0rko_0";

  home.packages = with pkgs; [
    telegram-desktop
    claude-code
  ];

  # Заменить на актуальную версию при установке
  home.stateVersion = "25.11";
}
