{
  config,
  pkgs,
  ...
}:

let
  cfg = config.icedos;

  browser =
    {
      librewolf = ''
        run librewolf
        ${if (cfg.applications.librewolf.pwas.enable) then "run librewolf-pwas" else ""}
      '';

      zen = ''
        run zen
        ${if (cfg.applications.zen-browser.pwas.enable) then "run zen-pwas" else ""}
      '';
    }
    .${cfg.applications.defaultBrowser};
in
{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "hyprland-startup" ''
      run () {
        pidof $1 || $1 $2 &
      }

      # Basic functionalities
      run hyprpaper
      xrandr --output "${cfg.desktop.hyprland.mainMonitor}" --primary
      run poweralertd
      run hyprlux

      # Standard applications
      ${browser}
      nautilus -w &
      nautilus -w &
      run steam
      run flare
      run zeditor

      # Terminals/Task managers
      kitty --class task-managers btop &
      kitty --class terminals tmux new -s terminals \; split-window -v \; select-pane -U \; split-window -h \; select-pane -D &
    '')
  ];
}
