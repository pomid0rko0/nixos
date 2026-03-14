{ config, pkgs, lib, ... }:

{
  # PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Отключить PulseAudio (несовместим с PipeWire pulse bridge)
  hardware.pulseaudio.enable = false;

  # RealtimeKit — позволяет PipeWire запрашивать приоритет реального времени
  security.rtkit.enable = true;
}
