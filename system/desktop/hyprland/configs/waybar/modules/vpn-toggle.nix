{ config, pkgs, ... }:

pkgs.writeShellScriptBin "vpn-toggle" ''
  interface=`nmcli d show | jc --nmcli | jq -rc '[.[] | select(.ip4_gateway != null) | { "connection": .connection, "ip4_gateway": .ip4_gateway }][0]'`
  interfaceName=`echo "$interface" | jq -r ".connection"`
  interfaceGateway=`echo "$interface" | jq -r ".ip4_gateway"`

  if [ "$interfaceGateway" = '192.168.1.1' ]; then
    nmcli con mod "$interfaceName" ipv4.gateway ${config.icedos.hardware.devices.server.ip}
  else
    nmcli con mod "$interfaceName" ipv4.gateway ${config.icedos.hardware.devices.server.gateway}
  fi

  nmcli con up "$interfaceName"
  pstree -A -p "`cat /tmp/vpn-watcher.pid`" | grep -Eow '\w+.[0-9]+.' | grep -e curl -e sleep | grep -Eow '[0-9]+' | xargs kill -9
''
