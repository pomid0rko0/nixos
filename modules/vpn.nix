{ config, pkgs, ... }:

{
  # --- VPN / Прокси ---
  # Раскомментировать нужный вариант (только один одновременно)

  # v2raya — веб-интерфейс, xray-core, подписки, автозапуск
  # Настройка: http://localhost:2017
  services.v2raya.enable = true;

  # daed — eBPF-прокси, веб-интерфейс, подписки, автозапуск
  # Настройка: http://localhost:2023
  # services.daed.enable = true;

  # sing-box — без GUI, конфиг вручную (JSON)
  # services.sing-box = {
  #   enable = true;
  #   settings = { };  # см. sing-box.sagernet.org/configuration
  # };

  # V2RayN — GUI-клиент (без автотуннелирования при запуске)
  # environment.systemPackages = [ pkgs.v2rayn ];
}
