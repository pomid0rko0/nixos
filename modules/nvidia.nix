{ config, pkgs, ... }:

{
  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  boot.kernelParams = [ "nvidia_drm.fbdev=1" ];

  # Драйвер NVIDIA
  services.xserver.videoDrivers = [ "nvidia" ];

  # Аппаратное ускорение графики
  hardware.graphics.enable = true;

  # Настройки драйвера NVIDIA
  hardware.nvidia = {
    modesetting.enable = true;     # обязательно для Wayland
    open = true;                   # открытый модуль ядра
    nvidiaSettings = true;         # утилита nvidia-settings
    powerManagement.enable = true; # корректный сон/пробуждение
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Переменные окружения для NVIDIA + Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    LIBVA_DRIVER_NAME = "nvidia";
  };
}
