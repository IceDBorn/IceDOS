{
  config,
  pkgs,
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
pkgs.writeShellScriptBin "hyprland-startup" ''
  run () {
    pidof $1 || $1 $2 &
  }

  # Basic functionalities
  systemctl --user start hyprpolkitagent
  run valent
  cliphist wipe
  run hyprland-per-window-layout
  run hyprpaper
  run swaync
  run swayosd-server
  wl-paste --type image --watch cliphist store &
  wl-paste --type text --watch cliphist store &
  xrandr --output "${cfg.desktop.hyprland.mainMonitor}" --primary
  run poweralertd
  run hyprlux

  # Tray applications
  nm-applet --indicator &

  # Standard applications
  ${browser}
  nautilus -w &
  nautilus -w &
  run steam
  run overskride
  run pavucontrol
  run signal-desktop
  run zeditor

  # Terminals/Task managers
  kitty --class task-managers btop &
  kitty --class terminals tmux new -s terminals \; split-window -v \; select-pane -U \; split-window -h \; select-pane -D &
''
