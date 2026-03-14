{ config, pkgs, lib, ... }:

{
  networking.hostName = "vector";

  # NetworkManager — Wi-Fi, проводное подключение, VPN
  networking.networkmanager.enable = true;

  # Межсетевой экран — включён, порты не открыты
  networking.firewall.enable = true;
}
