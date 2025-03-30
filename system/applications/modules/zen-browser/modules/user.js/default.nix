{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    listToAttrs
    mapAttrs
    mkIf
    substring
    ;

  cfg = config.icedos;
  accentColor = cfg.internals.accentColor;
  firefoxVersion = substring 0 5 pkgs.firefox.version;

  userJs = ''
    user_pref("browser.download.always_ask_before_handling_new_types", false);
    user_pref("browser.newtabpage.enabled", false);
    user_pref("browser.search.separatePrivateDefault", false);
    user_pref("browser.shell.checkDefaultBrowser", false);
    user_pref("browser.startup.homepage", "chrome://browser/content/blanktab.html");
    user_pref("browser.toolbars.bookmarks.visibility", "always");
    user_pref("dom.webgpu.enabled", true);
    user_pref("general.autoScroll", true);
    user_pref("general.useragent.override", "Mozilla/5.0 (X11; Linux x86_64; rv:${firefoxVersion}) Gecko/${firefoxVersion} Firefox/${firefoxVersion}");
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
    user_pref("zen.view.compact.hide-tabbar", true);
    user_pref("zen.view.compact.hide-toolbar", true);
    user_pref("zen.view.show-newtab-button-border-top", false);
    user_pref("zen.view.sidebar-expanded.on-hover", false);
    user_pref("zen.view.use-single-toolbar", false);
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
  '';
in
mkIf (cfg.applications.zen-browser.enable) {
  home-manager.users = mapAttrs (user: _: {
    home.file = listToAttrs (
      map (profile: {
        name = ".zen/${profile.exec}/user.js";

        value = {
          text =
            if (!profile.pwa) then
              userJs
            else
              userJs
              + ''
                user_pref("browser.toolbars.bookmarks.visibility", "never");
                user_pref("zen.tab-unloader.enabled", false);
                user_pref("zen.view.sidebar-expanded", false);
                user_pref("zen.view.compact.hide-tabbar", false);
              '';
        };
      }) cfg.applications.zen-browser.profiles
    );
  }) cfg.system.users;
}
