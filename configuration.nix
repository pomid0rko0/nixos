{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/disko.nix
    ./modules/hardware.nix
    ./modules/nvidia.nix
    ./modules/desktop.nix
    ./modules/gaming.nix
    ./modules/sound.nix
    ./modules/networking.nix
    ./modules/profiles.nix
    ./modules/vpn.nix
  ];

  # Загрузчик — systemd-boot (UEFI)
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # Часовой пояс и язык
  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "ru_RU.UTF-8";
  environment.sessionVariables.LANGUAGE = "ru:en";

  # Закрытие крышки — только блокировка, без засыпания
  services.logind = {
    lidSwitch = "lock";
    lidSwitchExternalPower = "lock";
    # игнорировать действия при подключенном мониторе
    lidSwitchDocked = "ignore";
  };

  # PAM для hyprlock (разрешение на проверку пароля)
  security.pam.services.hyprlock = {};

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
    jdk17  # Java для Minecraft (большинство версий)
    jdk21  # Java для новых версий
  ];

  # Несвободные пакеты (NVIDIA, Steam)
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
