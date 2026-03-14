{ config, pkgs, ... }:

let
  wallpaperHome = "${config.home.homeDirectory}/.local/share/wallpapers";

  hyprlock-wallpaper = pkgs.writeShellScriptBin "hyprlock-wallpaper" ''
    CONFIG=$(mktemp /tmp/hyprlock-XXXXXX.conf)
    trap 'rm -f "$CONFIG"' EXIT

    cat > "$CONFIG" <<HEADER
    general {
      hide_cursor = true
    }

    input-field {
      size = 200, 50
      outline_thickness = 3
      fade_on_empty = true
      placeholder_text =
    }
    HEADER

    # Для каждого монитора: подобрать обоину по разрешению
    ${pkgs.wlr-randr}/bin/wlr-randr | awk '
      /^[^ ]/ { output=$1 }
      /current/ {
        for (i=1; i<=NF; i++) {
          if ($i ~ /^[0-9]+x[0-9]+$/) { print output, $i; break }
        }
      }
    ' | while read -r output res; do
      wallpaper="${wallpaperHome}/firewatch_cool_twilight_''${res}.png"
      fallback="${wallpaperHome}/firewatch_cool_twilight_3840x2160.png"
      target="$wallpaper"
      if [ ! -f "$target" ] && [ -f "$fallback" ]; then
        target="$fallback"
      fi
      if [ -f "$target" ]; then
        cat >> "$CONFIG" <<BLOCK

    background {
      monitor = $output
      path = $target
    }
    BLOCK
      fi
    done

    ${pkgs.hyprlock}/bin/hyprlock --config "$CONFIG"
  '';
in
{
  programs.hyprlock.enable = true;

  # hypridle — автоблокировка при бездействии
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock-wallpaper";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "wlopm --on '*'";
      };

      listener = [
        # Блокировка через 5 минут бездействия
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        # Гашение экрана через 10 минут бездействия (5 после блокировки)
        {
          timeout = 600;
          on-timeout = "wlopm --off '*'";
          on-resume = "wlopm --on '*'";
        }
      ];
    };
  };

  # wlopm — управление питанием мониторов
  home.packages = [
    pkgs.wlopm
    hyprlock-wallpaper
  ];
}
