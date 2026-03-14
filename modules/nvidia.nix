{ config, pkgs, lib, ... }:

{
  # Драйвер NVIDIA
  services.xserver.videoDrivers = [ "nvidia" ];

  # Аппаратное ускорение графики
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true; # 32-битные библиотеки для Steam/Wine

  # Настройки драйвера NVIDIA
  hardware.nvidia = {
    modesetting.enable = true;     # обязательно для Wayland
    open = true;                   # открытый модуль ядра
    nvidiaSettings = true;         # утилита nvidia-settings
    powerManagement.enable = true; # корректный сон/пробуждение
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Переменные окружения для NVIDIA + Wayland
  # GBM_BACKEND, __GLX_VENDOR_LIBRARY_NAME, LIBVA_DRIVER_NAME —
  # только в режиме «только NVIDIA» (без PRIME offload).
  # В PRIME offload рабочий стол работает на Intel iGPU.
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    GDK_BACKEND = "wayland";
  } // lib.optionalAttrs (!config.hardware.nvidia.prime.offload.enable) {
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
  };
}
