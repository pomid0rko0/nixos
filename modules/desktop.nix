{ pkgs, ... }:

{
  # GNOME
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Раскладка клавиатуры (для GDM / X11)
  services.xserver.xkb = {
    layout = "us,ru";
    options = "grp:win_space_toggle";
  };

  # Шрифты
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      jetbrains-mono
    ];
    fontconfig.defaultFonts.monospace = [ "JetBrains Mono" ];
  };
}
