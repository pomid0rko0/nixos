{ config, pkgs, ... }:

{
  # Mango WM — пользовательская настройка
  wayland.windowManager.mango = {
    enable = true;
    settings = ''
      # Раскладки клавиатуры: английская и русская
      xkb_rules_layout=us,ru
      xkb_rules_options=grp:win_space_toggle

      numlockon=1

      # Автозапуск
      exec-once=wl-paste --watch cliphist store
      exec-once=waybar
      exec-once=wallpaper-set
      exec-once=${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1
    '';
  };
}
