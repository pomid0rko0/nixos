{ config, pkgs, firefox-addons, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.default = {
      isDefault = true;

      extensions.packages = with firefox-addons; [
        ublock-origin
        sponsorblock
        clearurls
        consent-o-matic
        decentraleyes
        facebook-container
        privacy-badger
        return-youtube-dislikes
      ];

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
        default = "Google";
        force = true;
        engines = {
          "Wikipedia" = {
            urls = [{ template = "https://ru.wikipedia.org/w/index.php?search={searchTerms}"; }];
            definedAliases = [ "@wiki" ];
          };
          "DuckDuckGo" = {
            urls = [{ template = "https://duckduckgo.com/?q={searchTerms}"; }];
            definedAliases = [ "@ddg" ];
          };
        };
      };
    };
  };
}
