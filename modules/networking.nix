{
  config,
  pkgs,
  lib,
  ...
}:

{
  networking.hostName = "vector";

  # NetworkManager — Wi-Fi, проводное подключение, VPN
  networking.networkmanager.enable = true;

  # SSH — только для генерации host key (agenix), сервер максимально закрыт
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = false;
      AllowTcpForwarding = false;
      AllowAgentForwarding = false;
      PermitTunnel = false;
    };
  };

  # Межсетевой экран — включён, порты не открыты
  networking.firewall.enable = true;

}
