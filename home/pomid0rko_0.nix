{ config, pkgs, mango, ... }:

{
  imports = [
    mango.hmModules.mango
    ./mango.nix
    ./shell.nix
    ./firefox.nix
    ./dev.nix
    ./gaming.nix
    ./waybar.nix
    ./fnott.nix
    ./screenlock.nix
    ./appearance
  ];

  home.username = "pomid0rko_0";
  home.homeDirectory = "/home/pomid0rko_0";

  # Базовые утилиты для Wayland-рабочего стола
  home.packages = with pkgs; [
    alacritty     # терминал
    rofi-wayland  # запускалка приложений, меню
    wayshot       # снимки экрана
    slurp         # выбор области экрана
    satty         # редактор снимков экрана
    wl-clipboard  # буфер обмена
    cliphist      # история буфера обмена
    brightnessctl      # управление яркостью
    pwvucontrol        # микшер звука
    telegram-desktop   # мессенджер
  ];

  # Заменить на актуальную версию при установке
  home.stateVersion = "25.11";
}
