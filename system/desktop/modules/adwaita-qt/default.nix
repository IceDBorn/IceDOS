{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs;
  cfg = config.icedos;
  accentColor = cfg.internals.accentColor;

  accentColorPatch = ''
    diff --git a/src/lib/stylesheet/processed/Adwaita-dark.css b/src/lib/stylesheet/processed/Adwaita-dark.css
    index 619bb32..27d5745 100644
    --- a/src/lib/stylesheet/processed/Adwaita-dark.css
    +++ b/src/lib/stylesheet/processed/Adwaita-dark.css
    @@ -3,13 +3,13 @@
     @define-color bg_color #353535;
     @define-color fg_color #eeeeec;
     @define-color selected_fg_color #ffffff;
    -@define-color selected_bg_color #15539e;
    +@define-color selected_bg_color ${accentColor};
     @define-color selected_borders_color #030c17;
     @define-color borders_color #1b1b1b;
     @define-color alt_borders_color #070707;
     @define-color borders_edge rgba(238, 238, 236, 0.07);
    -@define-color link_color #3584e4;
    -@define-color link_visited_color #1b6acb;
    +@define-color link_color ${accentColor};
    +@define-color link_visited_color ${accentColor};
     @define-color top_hilight rgba(238, 238, 236, 0.07);
     @define-color dark_fill #282828;
     @define-color headerbar_bg_color #2d2d2d;
    @@ -18,7 +18,7 @@
     @define-color scrollbar_bg_color #313131;
     @define-color scrollbar_slider_color #a4a4a3;
     @define-color scrollbar_slider_hover_color #c9c9c7;
    -@define-color scrollbar_slider_active_color #1b6acb;
    +@define-color scrollbar_slider_active_color ${accentColor};
     @define-color warning_color #f57900;
     @define-color error_color #cc0000;
     @define-color success_color #26ab62;
    @@ -44,16 +44,16 @@
     @define-color backdrop_selected_fg_color #d6d6d6;
     @define-color backdrop_borders_color #202020;
     @define-color backdrop_dark_fill #2e2e2e;
    -@define-color suggested_bg_color #15539e;
    +@define-color suggested_bg_color ${accentColor};
     @define-color suggested_border_color #030c17;
    -@define-color progress_bg_color #15539e;
    +@define-color progress_bg_color ${accentColor};
     @define-color progress_border_color #030c17;
    -@define-color checkradio_bg_color #15539e;
    +@define-color checkradio_bg_color ${accentColor};
     @define-color checkradio_fg_color #ffffff;
    -@define-color checkradio_borders_color #092444;
    -@define-color switch_bg_color #15539e;
    +@define-color checkradio_borders_color ${accentColor};
    +@define-color switch_bg_color ${accentColor};
     @define-color switch_borders_color #030c17;
    -@define-color focus_border_color rgba(21, 83, 158, 0.7);
    +@define-color focus_border_color ${accentColor};
     @define-color alt_focus_border_color rgba(255, 255, 255, 0.3);
     @define-color dim_label_opacity 0.55;
     button { color: #eeeeec; outline-color: rgba(21, 83, 158, 0.7); border-color: #1b1b1b; background-image: linear-gradient(to top, #373737 2px, #3a3a3a); box-shadow: 0 1px 2px rgba(0, 0, 0, 0.07); }
    @@ -86,10 +86,10 @@ checkradio:active { box-shadow: inset 0 1px black; background-image: image(#2828

     checkradio:disabled { box-shadow: none; color: rgba(255, 255, 255, 0.7); }

    -checkradio:checked { background-clip: border-box; background-image: linear-gradient(to bottom, #185fb4 20%, #15539e 90%); border-color: #092444; box-shadow: 0 1px rgba(0, 0, 0, 0.05); color: #ffffff; }
    +checkradio:checked { background-clip: border-box; background-image: ${accentColor}; border-color: #092444; box-shadow: 0 1px rgba(0, 0, 0, 0.05); color: #ffffff; }

    -checkradio:checked:hover { background-image: linear-gradient(to bottom, #1b68c6 10%, #185cb0 90%); }
    +checkradio:checked:hover { background-image: ${accentColor}; }

    -checkradio:checked:active { box-shadow: inset 0 1px black; background-image: image(#124787); }
    +checkradio:checked:active { box-shadow: inset 0 1px black; background-image: image(${accentColor}); }

     checkradio:checked:disabled { box-shadow: none; color: rgba(255, 255, 255, 0.7); }
  '';

  adwaitaQtBuilder = (
    let
      inherit accentColorPatch;
    in
    p:
    p.overrideAttrs (
      _: old: {
        patches = (old.patches or [ ]) ++ [ (builtins.toFile "adwaita-qt-accent.patch" accentColorPatch) ];
      }
    )
  );
in
{
  environment.systemPackages = with pkgs; [
    (adwaitaQtBuilder adwaita-qt)
    (adwaitaQtBuilder adwaita-qt6)
    kdePackages.qt6ct
    libsForQt5.qt5ct
  ];

  home-manager.users = mapAttrs (user: _: {
    home.file = {
      ".config/qt5ct/qt5ct.conf".source = ./qt5ct.conf;
      ".config/qt6ct/qt6ct.conf".source = ./qt6ct.conf;
    };
  }) cfg.system.users;
}
