{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.default = {
      isDefault = true;

      settings = {
        # --- Приватность ---
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "extensions.pocket.enabled" = false;
        "media.peerconnection.ice.default_address_only" = true;
        "privacy.trackingprotection.enabled" = true;
        "dom.security.https_only_mode" = true;
        "browser.send_pings" = false;

        # --- Производительность / Wayland ---
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "general.smoothScroll" = true;
      };

      search = {
        default = "google";
        force = true;
        engines = {
          "wikipedia" = {
            urls = [ { template = "https://ru.wikipedia.org/w/index.php?search={searchTerms}"; } ];
            definedAliases = [ "@wiki" ];
          };
          "ddg" = {
            urls = [ { template = "https://duckduckgo.com/?q={searchTerms}"; } ];
            definedAliases = [ "@ddg" ];
          };
        };
      };
    };
  };
}
