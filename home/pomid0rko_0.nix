{ config, pkgs, lib, ... }:

let
  inherit (lib.hm.gvariant) mkTuple;
in

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

  # Раскладка клавиатуры в GNOME: английская + русская, переключение по Super+Space
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      sources = [ (mkTuple [ "xkb" "us" ]) (mkTuple [ "xkb" "ru" ]) ];
      xkb-options = [ "grp:win_space_toggle" ];
    };
  };

  # Заменить на актуальную версию при установке
  home.stateVersion = "25.11";
}
