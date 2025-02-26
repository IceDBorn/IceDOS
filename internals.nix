{
  config,
  lib,
  ...
}:

let
  cfg = config.icedos;
in
{
  options.icedos.internals = with lib; {
    accentColor = mkOption {
      type = types.str;

      default =
        if (!cfg.desktop.gnome.enable) then
          "#${cfg.desktop.accentColor}"
        else
          {
            blue = "#3584e4";
            green = "#3a944a";
            orange = "#ed5b00";
            pink = "#d56199";
            purple = "#9141ac";
            red = "#e62d42";
            slate = "#6f8396";
            teal = "#2190a4";
            yellow = "#c88800";
          }
          .${cfg.desktop.gnome.accentColor};
    };

    isFirstBuild = mkOption { type = types.bool; };

    xfce4.files = mkOption {
      type = with types; attrsOf (submodule {
        options = {
          source = mkOption { default = null; };
          text = mkOption { default = null; };
        };
      });
      default = {};
    };
  };
}
