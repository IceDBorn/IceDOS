{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs mkIf;
  cfg = config.icedos;
  firefoxVersion = builtins.substring 0 5 pkgs.firefox.version;

  userJs = ''
    // Global settings
    user_pref("browser.download.autohideButton", true);
    user_pref("browser.theme.dark-private-windows", false);
    user_pref("general.autoScroll", true);
    user_pref("general.useragent.override", "Mozilla/5.0 (X11; Linux x86_64; rv:${firefoxVersion}) Gecko/20100101 Firefox/${firefoxVersion}");
    user_pref("identity.fxaccounts.enabled", true);
    user_pref("image.jxl.enabled", true); // Enable JPEG XL support
    user_pref("media.ffmpeg.vaapi.enabled", true); // Enable VA-API hard accelaration
    user_pref("middlemouse.paste", false);
    user_pref("privacy.resistFingerprinting", false);
    user_pref("svg.context-propertdies.content.enabled", true);
    user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
    user_pref("webgl.disabled", false);

    ${
      if (!cfg.applications.librewolf.privacy) then
        ''
          user_pref("privacy.clearOnShutdown.downloads", false);
          user_pref("privacy.clearOnShutdown.downloads", false);
          user_pref("privacy.clearOnShutdown.history", false);
          user_pref("privacy.clearOnShutdown.history", false);
          user_pref("services.sync.engine.history", true);
          user_pref("services.sync.engine.passwords", true);
          user_pref("services.sync.engine.tabs", true);
        ''
      else
        ""
    }
  '';
in
mkIf (cfg.applications.librewolf.enable) {
  home-manager.users = mapAttrs (user: _: {
    home.file.".librewolf/default/user.js".text = userJs;
    home.file.".librewolf/pwas/user.js".text =
      if (cfg.applications.librewolf.pwas.enable) then userJs else "";
  }) cfg.system.users;
}
