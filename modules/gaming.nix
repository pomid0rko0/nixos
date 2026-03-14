{ config, pkgs, lib, ... }:

{
  # Steam
  programs.steam = {
    enable = true;
};

  # Gamemode — оптимизация CPU, приоритеты процессов
  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };

}
