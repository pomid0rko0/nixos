{ config, pkgs, lib, ... }:

{
  # Ядро — последняя стабильная версия
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Микрокод Intel (Raptor Lake)
  hardware.cpu.intel.updateMicrocode = true;

  # Прошивки (Wi-Fi, Bluetooth и т.д.)
  hardware.enableRedistributableFirmware = true;

  # zram — сжатый swap в ОЗУ (8 ГБ)
  zramSwap.enable = true;
  zramSwap.memoryPercent = 50;

  # NVMe SSD — периодическая очистка блоков
  services.fstrim.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Обновление прошивок ноутбука (UEFI, контроллеры и т.д.)
  services.fwupd.enable = true;

  # Термоуправление (Intel)
  services.thermald.enable = true;
}
