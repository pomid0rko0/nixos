{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 30;

      modules-left = [
        "network"
        "bluetooth"
        "wireplumber"
        "custom/keyboard"
      ];
      modules-center = [
        "clock"
      ];
      modules-right = [
        "custom/power-mode"
        "tray"
      ];

      clock = {
        format = "{:%H:%M}";
        format-alt = "{:%Y-%m-%d %H:%M}";
        tooltip-format = "{:%A, %d %B %Y}";
      };

      network = {
        format-wifi = "WiFi {signalStrength}%";
        format-ethernet = "Eth";
        format-disconnected = "Нет сети";
        tooltip-format-wifi = "{essid} ({signalStrength}%)";
        tooltip-format-ethernet = "{ifname}: {ipaddr}";
      };

      bluetooth = {
        format = "BT {status}";
        format-connected = "BT {device_alias}";
        format-disabled = "BT выкл";
        tooltip-format-connected = "{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_alias}: {device_battery_percentage}%";
      };

      wireplumber = {
        format = "Звук {volume}%";
        format-muted = "Звук выкл";
        on-click = "pwvucontrol";
      };

      "custom/keyboard" = {
        exec = "mmsg -w -k";
        format = "{}";
        tooltip = false;
      };

      # Кнопка переключения подрежима (ECO/PERF).
      # Видна только в переносном профиле (portable).
      # В стационарном (module_blacklist=i915 в cmdline) — скрыта.
      "custom/power-mode" = {
        exec = "if grep -q module_blacklist=i915 /proc/cmdline; then echo ''; else power-mode waybar; fi";
        interval = 5;
        on-click = "pkexec power-mode toggle";
        format = "{}";
        tooltip = false;
      };

      tray = {
        spacing = 8;
      };
    };
  };
}
