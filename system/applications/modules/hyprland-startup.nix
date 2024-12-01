{
  config,
  pkgs,
}:

let
  browser =
    if (cfg.applications.librewolf.enable && cfg.applications.librewolf.default) then
      "run librewolf"
    else if (cfg.applications.zen-browser.enable && cfg.applications.zen-browser.default) then
      "run zen"
    else
      "";

  cfg = config.icedos;

  pwas =
    if
      (
        cfg.applications.librewolf.enable
        && cfg.applications.librewolf.default
        && cfg.applications.librewolf.pwas.enable
      )
    then
      "run librewolf-pwas"
    else if
      (
        cfg.applications.zen-browser.enable
        && cfg.applications.zen-browser.default
        && cfg.applications.zen-browser.pwas.enable
      )
    then
      "run zen-pwas"
    else
      "";
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
  ${pwas}
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
