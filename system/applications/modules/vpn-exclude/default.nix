{
config,
pkgs,
...
}:

let
  cfg = config.icedos.hardware.networking;
in
{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "vpn-exclude" ''
      INTERFACE=$(ip -o -4 route show to default | awk '{print $5}')
      GATEWAY=$(ip -o -4 route show to default | awk '{print $3}')
      NAMESPACE="vpnexcludens"
      LINK="vpnexcludelink"

      [ -f "/var/run/netns/$NAMESPACE" ] || sudo bash -c "
        (
          ip netns add $NAMESPACE
          ip link add $LINK link $INTERFACE address 00:11:22:33:44:55 type macvlan mode bridge
          ip link set $LINK netns $NAMESPACE

          ip netns exec $NAMESPACE ip link set dev lo up
          ip netns exec $NAMESPACE ip link set dev $LINK up

          ip netns exec $NAMESPACE ip addr add ${cfg.vpnExcludeIp}/24 dev $LINK
          ip netns exec $NAMESPACE ip route add default via $GATEWAY dev $LINK
        )
      "

      sudo ip netns exec "$NAMESPACE" sudo -u "$USER" "$1"
    '')
  ];
}
