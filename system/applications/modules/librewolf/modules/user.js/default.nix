{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mapAttrs
    mkIf
    substring
    ;

  cfg = config.icedos;
  firefoxVersion = substring 0 5 pkgs.firefox.version;
in
mkIf (cfg.applications.librewolf) {
  home-manager.users = mapAttrs (user: _: {
    programs.librewolf.settings = {
      "browser.download.autohideButton" = true;
      "browser.theme.dark-private-windows" = false;
      "general.autoScroll" = true;
      "general.useragent.override" =
        "Mozilla/5.0 (X11; Linux x86_64; rv:${firefoxVersion}) Gecko/20100101 Firefox/${firefoxVersion}";
      "identity.fxaccounts.enabled" = true;
      "image.jxl.enabled" = true; # Enable JPEG XL support
      "media.ffmpeg.vaapi.enabled" = true; # Enable VA-API hard accelaration
      "middlemouse.paste" = false;
      "privacy.resistFingerprinting" = false;
      "svg.context-properties.content.enabled" = true;
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "webgl.disabled" = false;
    };
  }) cfg.system.users;
}
