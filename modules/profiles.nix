{ config, pkgs, lib, ... }:

let
  power-mode = pkgs.writeShellScriptBin "power-mode" ''
    STATE_FILE="/run/power-mode"

    get_mode() {
      if [ -f "$STATE_FILE" ]; then cat "$STATE_FILE"
      else echo "economy"; fi
    }

    set_performance() {
      ${config.boot.kernelPackages.cpupower}/bin/cpupower frequency-set -g performance
      mkdir -p /etc/systemd/logind.conf.d
      cat > /etc/systemd/logind.conf.d/90-power-mode.conf <<'CONF'
[Login]
HandleLidSwitch=lock
HandleLidSwitchExternalPower=lock
HandleLidSwitchDocked=ignore
CONF
      systemctl kill -s HUP systemd-logind
      echo "performance" > "$STATE_FILE"
    }

    set_economy() {
      ${config.boot.kernelPackages.cpupower}/bin/cpupower frequency-set -g powersave
      rm -f /etc/systemd/logind.conf.d/90-power-mode.conf
      systemctl kill -s HUP systemd-logind
      echo "economy" > "$STATE_FILE"
    }

    case "''${1:-status}" in
      performance) set_performance ;;
      economy)     set_economy ;;
      toggle)
        if [ "$(get_mode)" = "economy" ]; then set_performance
        else set_economy; fi
        ;;
      status)
        MODE=$(get_mode)
        GOV=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo "н/д")
        echo "Подрежим: $MODE"
        echo "CPU governor: $GOV"
        ;;
      waybar)
        MODE=$(get_mode)
        if [ "$MODE" = "economy" ]; then echo "ECO"
        else echo "PERF"; fi
        ;;
      *)
        echo "Использование: power-mode {performance|economy|toggle|status|waybar}"
        exit 1
        ;;
    esac
  '';

  # Polkit: разрешить активному пользователю запускать power-mode без пароля
  power-mode-policy = pkgs.writeTextFile {
    name = "power-mode-polkit-policy";
    destination = "/share/polkit-1/actions/org.nixos.power-mode.policy";
    text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE policyconfig PUBLIC
       "-//freedesktop//DTD PolicyKit Policy Configuration 1.0//EN"
       "http://www.freedesktop.org/standards/PolicyKit/1/policyconfig.dtd">
      <policyconfig>
        <action id="org.nixos.power-mode">
          <description>Switch power mode</description>
          <message>Authentication is required to switch power mode</message>
          <defaults>
            <allow_any>auth_admin</allow_any>
            <allow_inactive>auth_admin</allow_inactive>
            <allow_active>yes</allow_active>
          </defaults>
          <annotate key="org.freedesktop.policykit.exec.path">${power-mode}/bin/power-mode</annotate>
          <annotate key="org.freedesktop.policykit.exec.allow_gui">true</annotate>
        </action>
      </policyconfig>
    '';
  };
in
{
  # === База: стационарный профиль (по умолчанию) ===
  system.nixos.tags = [ "stationary" ];
  powerManagement.cpuFreqGovernor = "performance";

  # Блокировка встроенной графики Intel (режим «только NVIDIA»).
  # Требует MUX-переключатель в BIOS в режиме MSHybrid.
  boot.kernelParams = [ "module_blacklist=i915" ];

  # === Переносной профиль ===
  specialisation.portable.configuration = { config, pkgs, lib, ... }: {

    # GPU: PRIME offload (Intel для рабочего стола, NVIDIA по запросу)
    hardware.nvidia.prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true; # команда nvidia-offload
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    # Отключение NVIDIA при простое
    hardware.nvidia.powerManagement.finegrained = true;

    # Убрать блокировку i915, добавить resume для гибернации
    boot.kernelParams = lib.mkForce [
      "resume=/dev/disk/by-partlabel/disk-main-swap"
    ];
    boot.resumeDevice = "/dev/disk/by-partlabel/disk-main-swap";

    # По умолчанию при загрузке: экономный подрежим
    powerManagement.cpuFreqGovernor = lib.mkForce "powersave";

    # Крышка: гибернация (переопределяется скриптом power-mode при смене подрежима)
    services.logind.lidSwitch = lib.mkForce "hibernate";
    services.logind.lidSwitchExternalPower = lib.mkForce "hibernate";
    services.logind.lidSwitchDocked = lib.mkForce "hibernate";

    # Скрипт переключения подрежимов + polkit-политика
    environment.systemPackages = [ power-mode power-mode-policy ];
  };
}
