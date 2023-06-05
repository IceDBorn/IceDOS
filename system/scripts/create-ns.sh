#!/usr/bin/env bash

UPLINK=$1
IP=$2
GATEWAY=$3

if [ $# -ne 3 ]; then
  echo 1>&2 "$0: Exactly three arguments are needed, in this particular order..."
  echo 1>&2 "$0: Uplink, IP, Gateway"
  exit 1
fi

DEFAULT_SHELL=$(readlink -f /proc/$PPID/exe)

LINK_NAME=$(cat /proc/sys/kernel/random/uuid | tr -d '-' | head -c 10)
NAMESPACE_NAME=$(cat /proc/sys/kernel/random/uuid | tr -d '-' | head -c 10)

TO_EXPORT_ENV="UPLINK IP GATEWAY DEFAULT_SHELL LINK_NAME NAMESPACE_NAME"
TO_EXPORT_FUN="create_namespace configure_namespace execute"

create_namespace () {
  ip link add $LINK_NAME link $UPLINK type macvlan mode bridge
  ip netns add $NAMESPACE_NAME
  ip link set $LINK_NAME netns $NAMESPACE_NAME
}

configure_namespace () {
  ip netns exec $NAMESPACE_NAME bash -c "
    ip link set lo up
    ip link set $LINK_NAME up
    ip addr add $IP dev $LINK_NAME
    ip route add default via $GATEWAY
  "
}

execute () {
  create_namespace
  configure_namespace
  ip netns exec $NAMESPACE_NAME su - $SUDO_USER bash -c "cd $PWD ; $DEFAULT_SHELL"
  ip netns delete $NAMESPACE_NAME
}

sudo \
   $(for x in $TO_EXPORT_ENV; do printf '%q=%q ' "$x" "${!x}"; done;) \
   bash -c "
     $(for x in $TO_EXPORT_FUN; do echo "$(declare -f $x)"; done;)
     execute
   "

