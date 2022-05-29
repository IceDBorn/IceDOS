#!/usr/bin/env bash

# Set power limits on all NVIDIA GPUs

# Make sure nvidia-smi exists
command -v nvidia-smi &> /dev/null || { echo >&2 "nvidia-smi not found ... exiting."; exit 1; }

# Change according to your card's max power limit
POWER_LIMIT=242
MAX_POWER_LIMIT=$(nvidia-smi -q -d POWER | grep 'Max Power Limit' | tr -s ' ' | cut -d ' ' -f 6)

if [[ ${POWER_LIMIT%.*}-1 -lt ${MAX_POWER_LIMIT%.*}+0 ]]; then
    /usr/bin/nvidia-smi --persistence-mode=1
    /usr/bin/nvidia-smi  --power-limit=${POWER_LIMIT}
else
    echo 'FAIL! POWER_LIMIT set above MAX_POWER_LIMIT ... '
    exit 1
fi

exit 0
