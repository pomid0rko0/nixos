{ config, pkgs, lib, ... }:

{
  # Mango WM (модуль из flake)
  programs.mango.enable = true;

  # Менеджер входа — greetd + ReGreet
  programs.regreet = {
    enable = true;
    settings = {
      commands = {
        reboot = [ "systemctl" "reboot" ];
        poweroff = [ "systemctl" "poweroff" ];
      };
    };
  };

  # Сессия Mango для ReGreet
  services.greetd.settings.default_session.command = "${pkgs.cage}/bin/cage -s -- ${pkgs.greetd.regreet}/bin/regreet";

  # XDG-порталы (общий доступ к экрану, диалоги файлов)
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config.common.default = [ "wlr" "gtk" ];
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Шрифты
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      jetbrains-mono
    ];
    fontconfig.defaultFonts = {
      monospace = [ "JetBrains Mono" ];
    };
  };

  # Файловый менеджер
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-volman
    thunar-archive-plugin
  ];

  # Polkit (привилегированные действия)
  security.polkit.enable = true;

  # Требуется для Stylix (GTK4/libadwaita тёмная тема через dconf)
  programs.dconf.enable = true;

  # Автомонтирование съёмных накопителей (USB и др.)
  services.udisks2.enable = true;
}
