{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    prismlauncher  # лаунчер Minecraft
    mangohud       # наложение FPS/температуры
    gamescope      # Wayland-микрокомпозитор для игр
    protonup-qt    # управление версиями GE-Proton
  ];
}
