{ pkgs, config }:
let
  monitor = config.icedos.hardware.monitors.main.name;
in
pkgs.writeShellScriptBin "hyprland-startup" ''
  run () {
    pidof $1 || $1 $2 &
  }

  # Basic functionalities
  run "${pkgs.libsForQt5.kdeconnect-kde}/libexec/kdeconnectd"
  run "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
  cliphist wipe
  run hyprland-per-window-layout
  run hyprpaper
  run swaync
  run swayosd
  sleep 2 && hyprctl reload
  sleep 2 && run waybar
  wl-paste --type image --watch cliphist store &
  wl-paste --type text --watch cliphist store &
  xrandr --output "${monitor}" --primary

  # Tray applications
  nm-applet --indicator &
  run kdeconnect-indicator

  # Standard applications
  firefox &
  firefox --no-remote -P PWAs --name pwas ${config.icedos.applications.firefox.pwas} &
  nautilus -w &
  nautilus -w &
  run steam

  # Terminals/Task managers/IDEs
  kitty --class task-managers tmux new -s task-managers nvtop \; split-window -h btop &
  kitty --class terminals tmux new -s terminals \; split-window -v \; select-pane -U \; split-window -h \; select-pane -D &
  kitty --class nvchad tmux new -s nvchad nvim &

  # Idle manager
  run hypridle
''
