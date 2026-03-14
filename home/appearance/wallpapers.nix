{ config, pkgs, ... }:

let
  wallpaperDir = ./wallpapers;
  wallpaperHome = "${config.home.homeDirectory}/.local/share/wallpapers";
  wallpaperFiles = builtins.attrNames (builtins.readDir wallpaperDir);

  wallpaper-set = pkgs.writeShellScriptBin "wallpaper-set" ''
    pkill swaybg || true

    # Для каждого монитора: определить разрешение, подобрать обоину
    ${pkgs.wlr-randr}/bin/wlr-randr | awk '
      /^[^ ]/ { output=$1 }
      /current/ {
        for (i=1; i<=NF; i++) {
          if ($i ~ /^[0-9]+x[0-9]+$/) { print output, $i; break }
        }
      }
    ' | while read -r output res; do
      wallpaper="${wallpaperHome}/firewatch_warm_sunset_''${res}.png"
      fallback="${wallpaperHome}/firewatch_warm_sunset_3840x2160.png"
      target="$wallpaper"
      if [ ! -f "$target" ] && [ -f "$fallback" ]; then
        target="$fallback"
      fi
      if [ -f "$target" ]; then
        ${pkgs.swaybg}/bin/swaybg -o "$output" -i "$target" -m fill &
      fi
    done
  '';
in
{
  # Все обои в ~/.local/share/wallpapers/
  home.file = builtins.listToAttrs (map (name: {
    name = ".local/share/wallpapers/${name}";
    value = { source = "${wallpaperDir}/${name}"; };
  }) wallpaperFiles);

  home.packages = [ wallpaper-set ];
}
