{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs mkIf;
  cfg = config.icedos;
  accentColor = cfg.internals.accentColor;
  firefoxVersion = builtins.substring 0 5 pkgs.firefox.version;

  userJs = ''
    user_pref("browser.download.always_ask_before_handling_new_types", false);
    user_pref("browser.newtabpage.enabled", false);
    user_pref("browser.search.separatePrivateDefault", false);
    user_pref("browser.shell.checkDefaultBrowser", false);
    user_pref("browser.startup.homepage", "chrome://browser/content/blanktab.html");
    user_pref("browser.toolbars.bookmarks.visibility", "always");
    user_pref("dom.webgpu.enabled", true);
    user_pref("general.autoScroll", true);
    user_pref("general.useragent.override", "Mozilla/5.0 (X11; Linux x86_64; rv:${firefoxVersion}) Gecko/20100101 Firefox/${firefoxVersion}");
    user_pref("media.videocontrols.picture-in-picture.video-toggle.enabled", false);
    user_pref("middlemouse.paste", false);
    user_pref("mousewheel.default.delta_multiplier_x", 250);
    user_pref("mousewheel.with_shift.delta_multiplier_y", 250);
    user_pref("toolkit.scrollbox.verticalScrollDistance", 2);
    user_pref("zen.splitView.change-on-hover", true);
    user_pref("zen.theme.accent-color", "${accentColor}");
    user_pref("zen.theme.color-prefs.amoled", true);
    user_pref("zen.theme.color-prefs.use-workspace-colors", false);
    user_pref("zen.urlbar.behavior", "float");
    user_pref("zen.view.compact", true);
    user_pref("zen.view.show-newtab-button-border-top", false);
    user_pref("zen.view.sidebar-expanded.on-hover", false);
    user_pref("zen.welcome-screen.seen", true);

    ${
      if (!cfg.applications.zen-browser.privacy) then
        ''
          user_pref("privacy.clearOnShutdown.downloads", false);
          user_pref("privacy.clearOnShutdown.history", false);
        ''
      else
        ''
          user_pref("browser.startup.page", 1);
          user_pref("browser.urlbar.suggest.history", false);
          user_pref("browser.urlbar.suggest.recentsearches", false);
          user_pref("pref.privacy.disable_button.cookie_exceptions", false);
          user_pref("privacy.clearOnShutdown_v2.historyFormDataAndDownloads", false);
          user_pref("privacy.history.custom", true);
          user_pref("privacy.sanitize.sanitizeOnShutdown", true);
          user_pref("signon.management.page.breach-alerts.enabled", false);
          user_pref("signon.rememberSignons", false);
        ''
    }

    // Overrides
    ${
      if (cfg.applications.zen-browser.overrides) then
        ''
          user_pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[\"_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action\",\"addon_simplelogin-browser-action\",\"addon_darkreader_org-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"sponsorblocker_ajay_app-browser-action\",\"skipredirect_sblask-browser-action\",\"jid1-kkzogwgsw3ao4q_jetpack-browser-action\",\"_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action\",\"pipewire-screenaudio_icenjim-browser-action\",\"_8540a13e-ae0f-4a36-a8a0-381bfe083ef8_-browser-action\",\"7esoorv3_alefvanoon_anonaddy_me-browser-action\",\"canvasblocker_kkapsner_de-browser-action\",\"languagetool-webextension_languagetool_org-browser-action\",\"plasma-browser-integration_kde_org-browser-action\",\"smart-referer_meh_paranoid_pk-browser-action\",\"_a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7_-browser-action\",\"_7efbd09d-90ad-47fa-b91a-08c472bdf566_-browser-action\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"urlbar-container\",\"unified-extensions-button\",\"wrapper-sidebar-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"vertical-tabs\":[],\"PersonalToolbar\":[\"personal-bookmarks\"],\"zen-sidebar-top-buttons\":[\"preferences-button\",\"zen-expand-sidebar-button\",\"zen-profile-button\"],\"zen-sidebar-icons-wrapper\":[\"zen-sidepanel-button\",\"zen-workspaces-button\",\"downloads-button\"]},\"seen\":[\"pipewire-screenaudio_icenjim-browser-action\",\"_8540a13e-ae0f-4a36-a8a0-381bfe083ef8_-browser-action\",\"7esoorv3_alefvanoon_anonaddy_me-browser-action\",\"canvasblocker_kkapsner_de-browser-action\",\"addon_darkreader_org-browser-action\",\"addon_simplelogin-browser-action\",\"jid1-kkzogwgsw3ao4q_jetpack-browser-action\",\"languagetool-webextension_languagetool_org-browser-action\",\"plasma-browser-integration_kde_org-browser-action\",\"smart-referer_meh_paranoid_pk-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action\",\"_a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7_-browser-action\",\"_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action\",\"_7efbd09d-90ad-47fa-b91a-08c472bdf566_-browser-action\",\"developer-button\",\"skipredirect_sblask-browser-action\",\"sponsorblocker_ajay_app-browser-action\"],\"dirtyAreaCache\":[\"unified-extensions-area\",\"nav-bar\",\"toolbar-menubar\",\"TabsToolbar\",\"PersonalToolbar\",\"vertical-tabs\",\"zen-sidebar-icons-wrapper\"],\"currentVersion\":20,\"newElementCount\":4}");
        ''
      else
        ""
    }
  '';
in
mkIf (cfg.applications.zen-browser.enable) {
  home-manager.users = mapAttrs (user: _: {
    home.file.".zen/default/user.js".text = userJs;
    home.file.".zen/pwas/user.js".text =
      if (cfg.applications.zen-browser.pwas.enable) then
        userJs
        + ''
          user_pref("browser.toolbars.bookmarks.visibility", "never");
          user_pref("zen.tab-unloader.enabled", false);
        ''
      else
        "";
  }) cfg.system.users;
}
