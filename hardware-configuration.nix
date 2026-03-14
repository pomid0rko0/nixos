# Заглушка. Заменить файлом, созданным командой:
#   nixos-generate-config --root /mnt
# при установке NixOS.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Разделы диска управляются через disko (modules/disko.nix).
  # Swap: раздел 17 ГБ (disko, для гибернации) + zramSwap 50% ОЗУ (modules/hardware.nix).
  # swapDevices пуст — disko монтирует swap-раздел самостоятельно.
  swapDevices = [ ];
}
