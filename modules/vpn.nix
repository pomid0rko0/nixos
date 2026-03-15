{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.tun2socks ];

  systemd.services.tun2socks = {
    description = "tun2socks";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStartPre = [
        "${pkgs.iproute2}/bin/ip tuntap add mode tun dev tun0"
        "${pkgs.iproute2}/bin/ip addr add 192.168.0.1/15 dev tun0"
        "${pkgs.iproute2}/bin/ip link set dev tun0 up"
      ];
      ExecStart = "${pkgs.tun2socks}/bin/tun2socks -device tun0 -proxy socks5://192.168.0.126:10808";
      ExecStartPost = [
        "${pkgs.iproute2}/bin/ip route add 192.168.0.0/24 dev wlo1 metric 0"
        "${pkgs.iproute2}/bin/ip route add default dev tun0 metric 1"
      ];
      ExecStopPost = [
        "${pkgs.iproute2}/bin/ip link delete tun0"
      ];
      Restart = "on-failure";
    };
  };
}
