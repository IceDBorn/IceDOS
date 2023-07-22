#!/bin/bash

DISCONNECTED=false
vpnState=$(curl -sS https://am.i.mullvad.net/check-ip/$(curl -sS https://ifconfig.me/ip || printf '0.0.0.0') | jq '.mullvad_exit_ip' || exit | grep true)

if [ ${#vpnState} -ge 1 ]; then
  if [ "$vpnState" = true ]; then
    echo "󰌾"
  else
    echo "󰿆"
  fi
else
  echo "<span foreground='red'>󰅛</span>"
fi
