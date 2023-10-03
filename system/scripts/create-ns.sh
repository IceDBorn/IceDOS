#!/usr/bin/env bash

if [ $# -lt 3 ]; then
    echo 1>&2 "$0: At least three arguments are needed, in this particular order..."
    echo 1>&2 "$0: Uplink, IP, Gateway, Optional: Command"
    exit 1
fi

UPLINK=$1
IP=$2
GATEWAY=$3
COMMAND=$4

DEFAULT_SHELL=$(readlink -f /proc/$PPID/exe)

LINK_NAME=$(cat /proc/sys/kernel/random/uuid | tr -d '-' | head -c 10)
NAMESPACE_NAME=$(cat /proc/sys/kernel/random/uuid | tr -d '-' | head -c 10)

CURRENT_ENV_FILE=$(mktemp)
chmod 600 $CURRENT_ENV_FILE
$DEFAULT_SHELL -c 'export -p' > $CURRENT_ENV_FILE

TO_EXPORT_ENV="UPLINK IP GATEWAY COMMAND DEFAULT_SHELL LINK_NAME NAMESPACE_NAME CURRENT_ENV_FILE"
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

    ip netns exec $NAMESPACE_NAME su - $SUDO_USER bash -c "
    set -a
    . $CURRENT_ENV_FILE
    rm $CURRENT_ENV_FILE
    set +a

    cd $PWD
    echo $COMMAND
    if [ ! '$COMMAND' -eq '' ]; then
      $COMMAND
    else
      $DEFAULT_SHELL
    fi
    "

    ip netns delete $NAMESPACE_NAME
}

sudo \
    $(for x in $TO_EXPORT_ENV; do printf '%q=%q ' "$x" "${!x}"; done;) \
    bash -c "
    $(for x in $TO_EXPORT_FUN; do echo "$(declare -f $x)"; done;)
    execute
"
