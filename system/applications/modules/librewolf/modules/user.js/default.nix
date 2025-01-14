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

    // Overrides
    ${
      if (cfg.applications.librewolf.overrides) then
        ''
          user_pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[\"ublock0_raymondhill_net-browser-action\",\"_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action\",\"_9abd6c79-c126-42cc-bacc-658d531864f1_-browser-action\",\"jid1-93cwpmrbvpjrqa_jetpack-browser-action\",\"_8540a13e-ae0f-4a36-a8a0-381bfe083ef8_-browser-action\",\"skipredirect_sblask-browser-action\",\"7esoorv3_alefvanoon_anonaddy_me-browser-action\",\"languagetool-webextension_languagetool_org-browser-action\",\"addon_simplelogin-browser-action\",\"_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action\",\"canvasblocker_kkapsner_de-browser-action\",\"addon_darkreader_org-browser-action\",\"firefox_tampermonkey_net-browser-action\",\"_react-devtools-browser-action\",\"_7efbd09d-90ad-47fa-b91a-08c472bdf566_-browser-action\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"urlbar-container\",\"save-to-pocket-button\",\"downloads-button\",\"unified-extensions-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\",\"ublock0_raymondhill_net-browser-action\",\"_9abd6c79-c126-42cc-bacc-658d531864f1_-browser-action\",\"jid1-93cwpmrbvpjrqa_jetpack-browser-action\",\"_8540a13e-ae0f-4a36-a8a0-381bfe083ef8_-browser-action\",\"skipredirect_sblask-browser-action\",\"7esoorv3_alefvanoon_anonaddy_me-browser-action\",\"languagetool-webextension_languagetool_org-browser-action\",\"addon_simplelogin-browser-action\",\"_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action\",\"_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action\",\"canvasblocker_kkapsner_de-browser-action\",\"addon_darkreader_org-browser-action\",\"firefox_tampermonkey_net-browser-action\",\"_react-devtools-browser-action\",\"_7efbd09d-90ad-47fa-b91a-08c472bdf566_-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\",\"PersonalToolbar\",\"unified-extensions-area\",\"toolbar-menubar\",\"TabsToolbar\"],\"currentVersion\":20,\"newElementCount\":4}");
          user_pref("browser.compactmode.show", true);
          user_pref("browser.tabs.drawInTitlebar", true);
          user_pref("browser.uidensity", 1);
          user_pref("dom.webgpu.enabled", true);
          user_pref("gfx.webrender.all", true);
          user_pref("media.ffvpx.enabled", false);
          user_pref("signon.rememberSignons", false);
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
