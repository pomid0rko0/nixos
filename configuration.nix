{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/disko.nix
    ./modules/hardware.nix
    ./modules/nvidia.nix
    ./modules/desktop.nix
    ./modules/sound.nix
    ./modules/networking.nix
    ./modules/vpn.nix
  ];

  # Загрузчик — systemd-boot (UEFI)
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # Часовой пояс и язык
  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";
  environment.sessionVariables.LANGUAGE = "en:ru";

  # Основной пользователь
  users.users.pomid0rko_0 = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "input" "video" "audio" "networkmanager" ];
  };

  # Необходимо для назначения zsh оболочкой пользователя
  programs.zsh.enable = true;

  # Базовые пакеты
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    htop
  ];

  # Несвободные пакеты (NVIDIA)
  nixpkgs.config.allowUnfree = true;

  # Включить flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Автоматическая сборка мусора — раз в 2 недели по средам, удаляет старше 30 дней
  nix.gc = {
    automatic = true;
    dates = "Wed *-*-1..7,15..21 03:00:00";
    persistent = true;
    options = "--delete-older-than 30d";
  };

  # Дедупликация файлов в /nix/store
  nix.optimise.automatic = true;

  # Заменить на актуальную версию при установке
  system.stateVersion = "25.11";
}
