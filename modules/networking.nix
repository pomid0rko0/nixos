{
  ...
}:

{
  networking.hostName = "vector";

  # DNS — публичные резервные серверы
  networking.nameservers = [
    "8.8.8.8"
    "1.1.1.1"
  ];

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
