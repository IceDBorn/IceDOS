{ pkgs }:

pkgs.writeShellScriptBin "vpn-watcher" ''
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
''
