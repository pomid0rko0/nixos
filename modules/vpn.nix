{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Имена подписок (не секретны, нужны для генерации фильтров)
  subNames = [
    "proxyliberty_vless"
    "proxyliberty_vless_wa"
    "proxyliberty_vless_wl"
  ];

  mkFiltersFor =
    subs: condition: modifier:
    lib.concatStringsSep "\n" (
      map (sub: "        filter: subtag(${sub}) && ${condition}${modifier}") subs
    );

  mkFilters = condition: mkFiltersFor subNames condition "";

  proxyCondition = "!name(keyword: 'Россия') && !name(keyword: 'Турция')";
  proxyFilters = builtins.concatStringsSep "\n" [
    (mkFiltersFor [ "proxyliberty_vless" ] proxyCondition "")
    (mkFiltersFor [ "proxyliberty_vless_wa" ] proxyCondition " [add_latency: +1000ms]")
    (mkFiltersFor [ "proxyliberty_vless_wl" ] proxyCondition " [add_latency: +5000ms]")
  ];
  torrentFilters = mkFilters "name(keyword: 'Torrent')";
  geminiFilters = builtins.concatStringsSep "\n" [
    (mkFilters "name(keyword: 'Gemini')")
    (mkFilters "!name(keyword: 'Россия') && !name(keyword: 'Турция') && !name(keyword: 'Gemini')")
  ];

  # Шаблон конфига dae — @SUBSCRIPTIONS@ заменяется при старте сервиса
  daeConfigTemplate = pkgs.writeText "dae-config-template" ''
    global {
        tproxy_port: 12345
        log_level: info
        wan_interface: auto
        auto_config_kernel_parameter: true
        tcp_check_url: 'https://cp.cloudflare.com'
        tcp_check_http_method: GET
        udp_check_dns: 'dns.google:53'
        check_interval: 30s
        check_tolerance: 50ms
        dial_mode: domain
        sniffing_timeout: 100ms
        utls_imitate: firefox_auto
    }

    subscription {
    @SUBSCRIPTIONS@
    }

    node {}

    dns {
        ipversion_prefer: 4

        upstream {
            googledns: 'tcp+udp://8.8.8.8:53'
            alidns: 'udp://223.5.5.5:53'
        }

        routing {
            request {
                qname(geosite:category-ru) -> alidns
                qname(geosite:geolocation-cn) -> alidns
                fallback: googledns
            }
            response {
                upstream(googledns) -> accept
                ip(geoip:private) && !qname(geosite:category-ru) && !qname(geosite:geolocation-cn) -> googledns
                fallback: accept
            }
        }
    }

    group {
        proxy {
    ${proxyFilters}
            policy: min_moving_avg
            tcp_check_url: 'https://www.youtube.com/generate_204'
            tcp_check_http_method: GET
        }

        torrent {
    ${torrentFilters}
            policy: min_moving_avg
        }

        gemini {
    ${geminiFilters}
            policy: min_moving_avg
            tcp_check_url: 'https://gemini.google.com'
            tcp_check_http_method: GET
        }
    }

    routing {
        pname(NetworkManager, systemd-resolved, dnsmasq) -> direct
        dip(8.8.8.8, 223.5.5.5) -> direct
        dip(224.0.0.0/3, 'ff00::/8') -> direct
        dip(geoip:private) -> direct
        domain(geosite:private) -> direct

        pname(qbittorrent) -> torrent
        pname(dota2, java) -> direct

        domain(geosite:category-ads-all) -> block
        domain(keyword: gemini.google.com, keyword: google.com) -> gemini

        domain(keyword: habr.com, keyword: theins.ru) -> proxy

        domain(suffix: ru, suffix: by, suffix: su, suffix: cn, suffix: xn--p1ai, suffix: xn--p1acf, suffix: xn--80aswg, suffix: xn--c1avg, suffix: xn--80asehdb) -> direct
        domain(geosite:category-ru) -> direct
        domain(geosite:geolocation-cn) -> direct
        domain(keyword: yandex, keyword: yastatic, keyword: yadi.sk, keyword: ya.com, keyword: tineye) -> direct
        domain(keyword: vk.com, keyword: userapi.com, keyword: vk-cdn, keyword: vk-portal, keyword: vk.cc, keyword: icq) -> direct
        dip(geoip:ru) -> direct
        dip(geoip:by) -> direct
        dip(geoip:cn) -> direct

        fallback: proxy
    }
  '';
in
{
  disabledModules = [ "services/networking/dae.nix" ];

  config = {
    age.secrets.vpn-subscriptions = {
      file = ../secrets/vpn-subscriptions.age;
    };
    services.dae = {
      enable = true;
      disableTxChecksumIpGeneric = false;
      configFile = "/etc/dae/config.dae";
    };

    systemd.services.dae.environment.GODEBUG = "netdns=cgo";

    system.activationScripts.dae-config = {
      deps = [ "agenixInstall" ];
      text = ''
        mkdir -p /etc/dae
        ${pkgs.gnused}/bin/sed '/@SUBSCRIPTIONS@/{r ${config.age.secrets.vpn-subscriptions.path}
        d}' ${daeConfigTemplate} > /etc/dae/config.dae
        chmod 600 /etc/dae/config.dae
      '';
    };
  };
}
