{ pkgs, lib, ... }:
let
  vpn-toggle = pkgs.writeShellScriptBin "vpn-toggle" ''
    interface=`nmcli d show | jc --nmcli | jq -rc '[.[] | select(.ip4_gateway != null) | { "connection": .connection, "ip4_gateway": .ip4_gateway }][0]'`
    interfaceName=`echo "$interface" | jq -r ".connection"`
    interfaceGateway=`echo "$interface" | jq -r ".ip4_gateway"`

    if [ "$interfaceGateway" = '192.168.1.1' ]; then
      nmcli con mod "$interfaceName" ipv4.gateway 192.168.1.2
    else
      nmcli con mod "$interfaceName" ipv4.gateway 192.168.1.1
    fi

    nmcli con up "$interfaceName"
    pstree -A -p "`cat /tmp/vpn-watcher.pid`" | grep -Eow '\w+.[0-9]+.' | grep -e curl -e sleep | grep -Eow '[0-9]+' | xargs kill -9
  '';

  vpn-watcher = pkgs.writeShellScriptBin "vpn-watcher" ''
    while :; do
      echo $$ > /tmp/vpn-watcher.pid
      ping -c1 9.9.9.9 >/dev/null 2>&1
      CONNECTED=$?

      vpnState=`
        curl -sS --connect-timeout 5 \
        https://am.i.mullvad.net/check-ip/$(curl -sS4 --connect-timeout 3 \
        https://ifconfig.me/ip || printf '0.0.0.0') | \
        jq '.mullvad_exit_ip' || exit | grep true \
      `

      if [ $CONNECTED -eq 0 ]; then
          if [ "$vpnState" = true ]; then
              echo "󰌾"
          else
              echo "󰿆"
          fi
      else
          echo "<span foreground='red'>󰅛</span>"
      fi

      sleep 5
    done
  '';
in {
  config.environment.systemPackages = with pkgs; [
    vpn-toggle
    vpn-watcher
    psmisc
  ];

  options = with lib; {
    desktop.hyprland.waybar.config = mkOption {
      type = types.str;
      default = ''
        {
          "layer": "top",
          "modules-left": ["hyprland/window"],
          "modules-center": ["hyprland/workspaces"] ,
          "modules-right": [
            "tray",
            "custom/vpn",
            "custom/separator",
            "bluetooth",
            "custom/separator",
            "hyprland/language",
            "custom/separator",
            "pulseaudio",
            "custom/separator",
            "clock",
            "custom/notification",
            "custom/separator",
            "custom/power",
          ],

          "bluetooth": {
            "format": "<span foreground='red'>󰂲</span>",
            "format-on": "󰂯",
            "format-off": "<span foreground='red'>󰂲</span>",
            "format-disabled": "󰂲",
            "format-connected": "󰂱",
            "format-connected-battery": "󰂱  {device_battery_percentage}",
            "tooltip-format": "{controller_alias}\t{controller_address}\n\n{num_connections} connected",
            "tooltip-format-connected": "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}",
            "tooltip-format-enumerate-connected": "{device_alias}\t{device_address}",
            "tooltip-format-enumerate-connected-battery": "{device_alias}\t{device_address}\t({device_battery_percentage})",
            "on-click": "overskride"
          },

          "tray": {
            "icon-size": 17,
            "spacing": 10,
            "reverse-direction" : true
          },

          "clock": {
            "interval": 1,
            "format": "{:%H:%M:%S}",
            "tooltip-format": "{:%A, %B %d, %Y}",
            "max-length": 25,
            "on-click": "gnome-clocks",
            "on-click-right": "gnome-calendar"
          },

          "pulseaudio": {
            "format": "{icon}  {volume}",
            "format-muted": "󰝟",
            "format-icons": {
              "headphone": "󰋋",
              "headset": "󰋎",
              "phone": "",
              "car": "󰄋",
              "default": ["󰕿", "󰖀", "󰕾"]
            },
            "scroll-step": 5,
            "on-click": "pavucontrol"
          },

          "hyprland/workspaces": {
            "format": "{icon}",
            "format-icons": {
              "active": "",
              "default": ""
            },
          },

          "hyprland/language": {
            "format": "{}",
            "format-en": "US",
            "format-gr": "GR",
            "on-click": "hyprctl switchxkblayout kingston-hyperx-alloy-fps-pro-mechanical-gaming-keyboard-1 next"
          },

          "hyprland/window": {
            "format": "{}",
            "separate-outputs": true,
            "max-length": 40
          },

          "custom/power": {
            "format": "",
            "on-click": "wlogout",
            "tooltip": false
          },

          "custom/vpn": {
            "format": "{}",
            "exec": "vpn-watcher",
            "on-click": "vpn-toggle",
            "return-type": "{}",
            "tooltip": false,
          },

          "custom/separator": {
            "format": "•",
            "tooltip": false
          },
          "custom/notification": {
            "tooltip": false,
            "format": "{icon}",
            "format-icons": {
              "dnd-notification": "<span foreground='white'><sup></sup></span>",
              "dnd-none": "<span foreground='white'><sup></sup></span>",
              "dnd-inhibited-notification": "<span foreground='white'><sup></sup></span>",
              "dnd-inhibited-none": "<span foreground='white'><sup></sup></span>"
            },
            "return-type": "json",
            "exec-if": "which swaync-client",
            "exec": "swaync-client -swb",
            "escape": true
          },
        }
      '';
    };
  };
}
