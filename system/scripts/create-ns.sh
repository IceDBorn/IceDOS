#!/usr/bin/env bash

POSITIONAL_ARGS=()

FLAG_USE_ANY_NS=0
FLAG_CREATE_NEW_NS=0
FLAG_USE_CONFIG_FILE=0

while [[ $# -gt 0 ]]; do
  case $1 in
    -a|--any)
      FLAG_USE_ANY_NS=1
      shift
      ;;
    -n|--new)
      FLAG_CREATE_NEW_NS=1
      shift
      ;;
    -c|--config-file)
      FLAG_USE_CONFIG_FILE=1
      CONFIG_FILE="$2"
      shift
      shift
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1")
      shift
      ;;
  esac
done

if [ "$FLAG_CREATE_NEW_NS" -eq "1" ] && [ "$FLAG_USE_ANY_NS" -eq "1" ]; then
  echo "Invalid flag combination" > /dev/stderr
  exit 1
fi

set -- "${POSITIONAL_ARGS[@]}"
COMMAND="$@"

DEFAULT_SHELL=$(readlink -f /proc/$PPID/exe)

NS_DIR="$XDG_RUNTIME_DIR/create-ns"
mkdir -p $NS_DIR
EXISTING_NAMESPACES=`ls "$NS_DIR/"`

_log () {
  if [[ "$DEBUG" -eq "1" ]]; then
    echo $@
  fi
}

create_namespace_interactive () {
  namespaceName=$(cat /proc/sys/kernel/random/uuid | tr -d '-' | head -c 10)
  linkName=$(cat /proc/sys/kernel/random/uuid | tr -d '-' | head -c 10)

  if [ "$FLAG_USE_CONFIG_FILE" -eq "1" ]; then
    source $CONFIG_FILE
  else
    printf "Uplink: "
    read uplink
    printf "IP: "
    read ip
    printf "Gateway: "
    read gateway
  fi

  _log "Creating namespace on Interface $uplink, with IP: $ip and Gateway: $gateway"

  sudo bash -c "
    set -e

    export UPLINK=$uplink
    export IP=$ip
    export GATEWAY=$gateway

    $(declare -f create_namespace)
    create_namespace $namespaceName $linkName
  "

  if [ ! "$?" -eq "0" ]; then
    sudo ip netns delete $namespaceName
    echo "Failure creating the netns" > /dev/stderr
    exit 1
  fi

  touch "$NS_DIR/$namespaceName"
  echo "uplink='$uplink'" >> "$NS_DIR/$namespaceName"
  echo "ip='$ip'" >> "$NS_DIR/$namespaceName"
  echo "gateway='$gateway'" >> "$NS_DIR/$namespaceName"
}

create_namespace () {
  if [ ! "$UID" -eq "0" ]; then
    echo Root is required! > /dev/stderr
    exit 1
  fi

  namespaceName=$1
  linkName=$2

  ip link add $linkName link $UPLINK type macvlan mode bridge
  ip netns add $namespaceName
  ip link set $linkName netns $namespaceName

  ip netns exec $namespaceName bash -c "
    ip link set lo up
    ip link set $linkName up
    ip addr add $IP dev $linkName
    ip route add default via $GATEWAY
  "
}

print_namespaces_list () {
  local i=1
  echo "$EXISTING_NAMESPACES" | while read ns; do
    printf "%3d %s %s\n" $i $ns `cat "$NS_DIR/$ns" | grep IP | sed 's/export ip=//' | tr -d "'"`
    i=`expr $i + 1`
  done
}

_log EXISTING_NAMESPACES=$EXISTING_NAMESPACES

# Menu
if [ "$FLAG_CREATE_NEW_NS" -eq 1 ]; then
  create_namespace_interactive
elif [ "`printf "$EXISTING_NAMESPACES" | wc -c`" -eq 0 ]; then
  _log There are no Network namespaces available.
  _log Creating new one ...

  create_namespace_interactive
elif [ "$FLAG_USE_ANY_NS" -eq 1 ]; then
  namespaceName=`ls $NS_DIR | head -n 1`
else
  echo "Select a namespace number, or type 'n' to create a new one:"
  list=`mktemp`
  print_namespaces_list | tee $list

  printf "Namespace number:"
  read number

  if [ "$number" -eq "n" ]; then
    create_namespace_interactive
  else
    echo "Selected $number"
    namespaceName=`grep -E "^\s+$number" $list | awk '{ print $2 }'`
    rm $list
    unset $list
  fi
fi

# Enter the namespace environment
CURRENT_ENV_FILE=$(mktemp)
chmod 600 $CURRENT_ENV_FILE
$DEFAULT_SHELL -c 'export -p' > $CURRENT_ENV_FILE

TO_EXPORT_ENV="COMMAND DEFAULT_SHELL CURRENT_ENV_FILE"
TO_EXPORT_FUN="execute"

execute () {
  namespaceName=$1

  ip netns exec $namespaceName su - $SUDO_USER bash -c "
    set -a
    . $CURRENT_ENV_FILE
    rm $CURRENT_ENV_FILE
    set +a

    cd $PWD
    if [ ! '$COMMAND' = '' ]; then
      $COMMAND
    else
      $DEFAULT_SHELL
    fi
  "
}

sudo bash -c "
  $(for x in $TO_EXPORT_ENV; do printf '%q=%q ' "$x" "${!x}"; done;)
  $(for x in $TO_EXPORT_FUN; do echo "$(declare -f $x)"; done;)
  execute $namespaceName
"
